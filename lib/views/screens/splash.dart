import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/LoadContent.dart';
import '../../utils/Preferences.dart';
import '../../utils/InitializationUtil.dart';
import '../widgets/linear_percent_indicator.dart';
import '../../data/models/config/DeviceConfig.dart';
import '../../data/models/DeviceMonitor.dart';
import '../../utils/DeviceUtil.dart';
import '../../utils/WebSocketUtil.dart';
import '../../data/models/config/Global7Config.dart';
import '../../utils/AppConfig.dart';
import 'mode3.dart' as mod3;

bool rpiFail = false;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  // @override
  // void initState() {
  //   super.initState();

  //   LoadContent.loadUriConfig((val) {
  //     print('Val $val');
  //   });

  //   Timer(
  //       Duration(seconds: 3),
  //       () => Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (BuildContext context) => NextPage())));
  // }
  //DatabaseHelper helper;
  double percent = 0.0;
  Stopwatch watch = Stopwatch();

  String? _rpi1;
  String? _rpi2;
  String? _screenModes;

  var timer;
  var duration;
  var interval;
  bool hasSent = false;

  String appVersion = "";
  final ReceivePort _port = ReceivePort();

  handleAppLifecycleState() {
    AppLifecycleState _lastLifecyleState;
    SystemChannels.lifecycle.setMessageHandler((msg) {
      print('SystemChannels> $msg');
      switch (msg) {
        case "AppLifecycleState.paused":
          _lastLifecyleState = AppLifecycleState.paused;
          break;
        case "AppLifecycleState.inactive":
          //Navigator.pushNamed(context, "/nextpage");
          _lastLifecyleState = AppLifecycleState.inactive;
          break;
        case "AppLifecycleState.resumed":
          _lastLifecyleState = AppLifecycleState.resumed;
          break;
        case "AppLifecycleState.detached":
          _lastLifecyleState = AppLifecycleState.detached;
          break;
        default:
      }
      return defMsg();
    });
  }

  Future<String?> defMsg() async {
    return "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //DatabaseHelper.instance.removeDB();

    handleAppLifecycleState();

    //Future.delayed(const Duration(seconds: 3), () {
    //Navigator.pushNamed(context, "/controlPanel");
    getSharedValues();
    // });
    //startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void validateScreen() {
    Preferences.getSharedValue("currentScreen").then((val) {
      if (val != null) {
        print("current screen == ${val}");
        Preferences.getSharedValue("currentScreen").then((val1) {
          Navigator.pushNamed(context, "/${val1}");
        });
      } else {
        Preferences.setSharedValue("currentScreen", "deviceMode");
        Navigator.pushNamed(context, '/devicecontrol');
      }
    });
  }

  getSharedValues() async {
    await AppConfig.getConfigs();
    setState(() {
      appVersion = AppConfig.appVersion ?? '';
    });
    _rpi1 = await Preferences.getSharedValue('rpi1');
    _rpi2 = await Preferences.getSharedValue('rpi2');
    _screenModes = await Preferences.getSharedValue('screenModes');
    //validate if there's a rpi set by the user.
    if (_rpi1 != null && _rpi2 != null) {
      //proceed with initialization
      var vDownloaded = await Preferences.getSharedInt("videoDownloaded");
      if (vDownloaded == null || vDownloaded < 6) {
        //if(await FileUtil.isFileExistsInAppDir('uberDisplayVideo.mp4')) {
        //print("VIDEO IS ALREADY DOWNLOADED");
        /*if(await FileUtil.isFileExistsInAppDir('video.mp4')) {
          print("FILE IS ALREADY IN APP DIRECTORY");
        } else {
          await FileUtil.moveFileToAppDir('video.mp4');
          print("FILE IS NOW COPIED TO APPS DIRECTORY");
        }*/
        //} else {
        /*if(await FileUtil.isFileExistsInAppDir('video.mp4')) {
          print("FILE IS ALREADY IN APP DIRECTORY");
        } else {*/
        initVideoDownload();
        //}
      }
      initIsolateCallback();
      initData();
    } else {
      //proceed with device configuration
      Preferences.setSharedValue("currentScreen", "deviceMode");
      Navigator.pushNamed(context, '/devicecontrol');
    }
  }

  static String strippedDownUrl(String uri) {
    String retVal = "";
    retVal = uri.replaceAll("http://", "");
    retVal = retVal.replaceAll("http://", "");
    return retVal;
  }

  void initIsolateCallback() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      String id = data[0];
      //DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      int progress = data[2];
      print("ISOLATE EXECUTION: TASK[${id}] PERCENTAGE[${progress}]");
      mod3.percentage = progress;
      if (progress == 100) {
        // completed
        //bool isVideoExists = await FileUtil.isFileExistsInDownloads('uberDisplayVideo.mp4');
        //print("VIDEO EXISTS! $isVideoExists");
        String key = "img_task_ids";
        List<String> imgTasks = await Preferences.getListValue(key);
        if (imgTasks.contains(id)) {
          print("▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓>>> IMAGE DOWNLOAD FINISHED [$id]");
          await LoadContent.reloadImageCarousel(id);
          imgTasks = await Preferences.getListValue(key);
          imgTasks.remove(id);
          Preferences.setListValue(key, imgTasks);
        } else {
          var vdownloaded = await Preferences.getSharedInt("videoDownloaded");
          if (vdownloaded == null) {
            Preferences.setSharedInt("videoDownloaded", 2);
            initVideoDownload();
          } else {
            if (vdownloaded < 6) {
              vdownloaded += 1;
              Preferences.setSharedInt("videoDownloaded", vdownloaded);
              initVideoDownload();
            }
          }
        }
        /*if(isVideoExists) {
          FileUtil.moveFileToAppDir('uberDisplayVideo.mp4');
        }*/
      }
      //final taskId = await Preferences.getSharedValue("taskId");
      //print("ISOLATE TASK ID: $taskId");
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  void initVideoDownload() async {
    // 0.tcp.ngrok.io:13997
    String baseUri = strippedDownUrl(_rpi1 ?? '');
    int cnt = 1;
    var downloads = await Preferences.getSharedInt("videoDownloaded");
    print("downloads: $downloads");
    if (downloads != null) {
      cnt = downloads;
    }
    String uri = "http://${baseUri}/files/video${cnt}.mp4";
    String localPath = (await _getSavedDir())!;
    // strip data
    // localPath = localPath.replaceAll("/data", "");
    print("LOCAL PATH: $localPath");
    //await FileUtil.getPermission();
    final taskId = await FlutterDownloader.enqueue(
        url: uri,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: localPath,
        showNotification:
            false, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        //saveInPublicStorage: true,
        fileName: 'uberDisplayVideo${cnt}.mp4');
    if (taskId != null) {
      Preferences.setSharedValue("taskId", taskId);
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;

    return externalStorageDirPath;
  }

  static int getSeconds(milli) {
    Duration dur = Duration(milliseconds: milli);
    return dur.inSeconds;
  }

  void initData() {
    //Preferences.getSharedValue("deviceNumber").then((val) {
    //if (val != null) {
    watch.reset();
    watch.start();
    print("WATCH START");
    InitializationUtil.initData(context, (percentVal) {
      setState(() {
        if (percent + percentVal < 1.0) {
          percent += percentVal;
        } else {
          percent = 1.0;
        }
        print("PERCENT: %${percent}");
      });
    }).then((dt) {
      int _duration = 3;
      if (dt == null) {
        setState(() {
          percent = 1.0;
          rpiFail = false;
          Preferences.setSharedValue("rpiFail", "false");
        });
      } else {
        _duration = 0;
        rpiFail = true;
        Preferences.setSharedValue("rpiFail", "true");
      }
      print("DT == $dt");
      watch.stop();
      print("WATCH STOP");
      print("Elapsed time{${watch.elapsedMilliseconds}ms}");
      print("Total loading: ${getSeconds(watch.elapsedMilliseconds)}");
      print('Screen Mode: $_screenModes');
      startTimer();
      if (_screenModes == 'mode1') {
        Future.delayed(Duration(seconds: _duration), () {
          Navigator.pushNamed(context, '/nextpage');
        });
      } else {
        Future.delayed(Duration(seconds: _duration), () {
          Navigator.pushNamed(context, '/mode2');
        });
      }
    });
    //}
    // else {
    //   Navigator.pushNamed(context, '/nextpage').then((val) {
    //     //Navigator.pushNamed(context, '/splash');
    //   });
    // }
    //});
  }

  startTimer() {
    interval = Global7Config.settings?.pingInterval ?? 20;
    duration = Duration(seconds: interval);
    timer = Timer(duration, () {
      sendDeviceInfo();
      startTimer();
    });
  }

  Future getMode() async {
    var mode = await Preferences.getSharedValue("displayMode");
    return mode;
  }

  sendDeviceInfo() async {
    if (DeviceConfig.deviceName == null) {
      return;
    }
    print("=========== SEND DEVICE INFORMATION =========");
    //var loadPerson = Get.find<LoadPerson>();
    print("DEVICE ID: ${DeviceConfig.deviceName}");
    //print("LOADED PERSON Profile: ${loadPerson.currentProfile.toString().replaceAll("UserProfiles.", "")}");
    //print("People ID: ${loadPerson.person?.id}");
    //print("Ping Interval: ${interval}");
    //print("DEVICE IP: ${await DeviceUtil.getIP()}");
    //print("Device No: ${DeviceConfig.deviceNum}");
    //print("Device ID: ${await DeviceUtil.getDeviceId()}");
    DeviceMonitor monitor = DeviceMonitor(
      deviceIp: await DeviceUtil.getIP(),
      deviceId: await DeviceUtil.getDeviceId(),
      battery: await DeviceUtil.batteryLevel(),
      deviceApp: "uberDisplay",
      deviceRole: await getMode() ?? "",
      plugged: await DeviceUtil.isPlugged(),
    );
    if (DeviceConfig.deviceName != null && !DeviceConfig.deviceName!.isEmpty) {
      monitor.deviceNo = DeviceConfig.deviceName!;
    }
    if (await DeviceUtil.isOnWifi()) {
      monitor.wifi = await DeviceUtil.wifiStrength();
    }
    Map<String, dynamic> objData = {
      "deviceUID": await DeviceUtil.getDeviceId(),
      "operation":
          (!hasSent) ? WSOperation.MonitorRegister : WSOperation.MonitorUpdate,
      "deviceMonitor": monitor.toMap()
    };
    WebSocketUtil.gameSend(objData);
    hasSent = true;
    print(objData);
    print("=============================================");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: InkWell(
      // onTap: () {
      //   Navigator.pushNamed(context, "/nextpage");
      // },
      child: Container(
        decoration: new BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.white, new Color(0xADC0BE)],
                focal: Alignment.center,
                radius: 1.0)),
        child: new Column(
          children: <Widget>[
            new Expanded(
                child: Container(
                    alignment: Alignment.center,
                    //color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: new ExactAssetImage(
                                    "assets/images/logo.png"),
                                fit: BoxFit.fitWidth),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 80.0,
                        ),
                        new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: MainAxisAlignment.center,
                          animation: true,
                          lineHeight: 15.0,
                          animationDuration: 2500,
                          animateFromLastPercent: true,
                          percent: percent,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Color(0xff848484),
                        )
                        // Text("SPLASH SCREEN",
                        //     style: new TextStyle(
                        //         fontSize: 28.0, fontWeight: FontWeight.w700)),
                        /*new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: MainAxisAlignment.center,
                          animation: true,
                          lineHeight: 15.0,
                          animationDuration: 2500,
                          animateFromLastPercent: true,
                          percent: percent,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Color(0xff848484),
                        )*/
                      ],
                    ))),
            Spacer(),
            Container(
              margin: EdgeInsets.all(25),
              child: Text("v${appVersion}"),
            ),
          ],
        ),
      ),
    ));
  }
}
