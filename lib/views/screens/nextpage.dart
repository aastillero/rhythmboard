import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/dao/TimeInfoDao.dart';
import '../../data/models/HeatSequence.dart';
import '../../data/models/ImageCarousel.dart';
import '../../data/models/JobPanelData.dart';
import '../../data/models/TimeInfo.dart';
import '../../data/models/config/DeviceConfig.dart';
import '../../data/models/config/Global6Config.dart';
import '../../data/models/config/HeatSequenceConfig.dart';
import '../../data/models/config/Global5Config.dart';
import '../../data/models/config/ImageCarouselConfig.dart';
import '../../data/models/ws/EntryData.dart';
import 'change_device_mode.dart';
import '../../utils/ConnectionUtil.dart';
import '../../utils/FileUtil.dart';
import '../../utils/HttpUtil.dart';
import '../../utils/JobPanelDataProcess.dart';
import '../../utils/LoadJobPanel.dart';
import '../widgets/mode1/ballroom_section.dart';
import '../widgets/mode1/bottom_branding.dart';
import '../widgets/mode1/done_section.dart';
import '../widgets/mode1/heat_section.dart';
import '../widgets/mode1/ondeck_section.dart';
import '../widgets/mode1/topbar.dart';
import '../../data/models/ws/carousel.dart';
import '../../data/models/ws/heats.dart';
import 'package:intl/intl.dart';
import '../../websocket/DanceFrameCommunication.dart';
import '../../utils/LoadContent.dart';
import '../../data/models/config/EventConfig.dart';
import '../../utils/Preferences.dart';
import '../../utils/WebSocketUtil.dart';
import '../../data/models/ws/WebSocketListener.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'mode3.dart' as mod3;
import 'mode3Test.dart' as mod3Test;

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage>
    with SingleTickerProviderStateMixin {
  String? labelTime;
  Timer? timer, carouselTimer;
  var doneSlide = 0;
  var heatSlide = 0;
  var deckSlide = 1;
  // var heatDescStarted;
  // var heatDescNext;
  //List<dynamic> heatDescDone = [];
  String? descName;
  bool animate = false;
  var initData;
  double percent = 0;
  List doneData = [];
  var genUrl;
  var toRemove = [];
  List<Heats> _heats = [];
  List<Carousel> _carousel = [];
  List<Widget> rightSlides = [];
  List<Widget> leftSlides = [];
  int danceLength = 0;

  // int nextHeatId = 0;
  int doneHeatId = 0;
  String? doneHeatName;
  String? heatDescDone;
  int heatId = 0;
  String? heatName;
  String? heatDescStarted;
  int? nextHeatId;
  String? nextHeatName;
  String? heatDescNext;

  List<JobPanelData>? _jobPanels;
  var _jobPanelData = JobPanelDataProcess();

  bool heatStarted = false;
  bool isAnimationRunning = false;

  double _width = 50.0;

  int dur = 0;

  String deviceNumber = "";
  bool isRPIFail = false;

  OverlayEntry? overlayEntry;

  DateTime? dateTime, _lastActiveTime;
  int reconnectDelay = 3;

  List<String> prefImgs = [];
  List<ImageCarousel>? imageCarousel;

  HeatSequence? heatStatus;

  get resp => null;

  bool toggle = false;

  int confRoomNumber = 1;

  void _updateState({bool stats = false, double defWidth = 50.0}) {
    if (!stats) {
      setState(() {
        _width = defWidth;
        dur = 0;
      });
    } else {
      setState(() {
        //dur = 6000;
        dur = danceLength * 1000;
        //_width = double.infinity;
        _width = MediaQuery.of(context).size.width * 0.428;
      });
    }
  }

  Future<List<Heats>> getHeats() async {
    var url = "http://${genUrl}/uberPlatform/cache/heats";
    var response = await http.get(Uri.parse(url));
    List<Heats> heats = [];
    print(response);
    try {
      if (response.statusCode == 200) {
        var heatsJson = json.decode(response.body);

        for (var heatJson in heatsJson) {
          heats.add(Heats.fromJson(heatJson));
        }
      }
      return heats;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  getCarousel(List<ImageCarousel>? imgCarousels) async {
    // var url = "http://${genUrl}/uberPlatform/uberdisplay/image/info/all";
    // var response = await http.get(Uri.parse(url));
    // List<Carousel> carousel = [];
    // try {
    //   if (response.statusCode == 200) {
    //     var carouselsJson = json.decode(response.body);

    //     for (var carouselJson in carouselsJson) {
    //       carousel.add(Carousel.fromJson(carouselJson));
    //     }
    //   }
    //   return carousel;
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }

    if (imgCarousels != null && imgCarousels.length > 0) {
      //print("====================== ImgCarousels: [${imgCarousels.length}]");
      for (var i = 0; i < imgCarousels.length; i++) {
        if (imgCarousels[i].enabled) {
          switch (imgCarousels[i].displayPos) {
            case 1:
              leftSlides.add(Container(
                width: double.infinity,
                child: (imgCarousels[i].imgBinary != null)
                    ? Image.memory(
                        imgCarousels[i].imgBinary!,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ));
              break;
            case 2:
              rightSlides.add(Container(
                width: double.infinity,
                child: (imgCarousels[i].imgBinary != null)
                    ? Image.memory(
                        imgCarousels[i].imgBinary!,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ));
              break;
            default:
          }
        }
      }
      //print("====================== LeftSlides: [${leftSlides.length}]");
      //print("====================== rightSlides: [${rightSlides.length}]");
    }
  }

  void setCarouselTimer() async {
    if (await isNeedTimer()) {
      carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        bool needTimer = await isNeedTimer();
        LoadContent.reloadCarousel();
        setState(() {
          imageCarousel = ImageCarouselConfig.settings ?? [];
          getCarousel(imageCarousel);
        });
        if (!needTimer) {
          print(
              "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ TIMER CANCELED ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
          carouselTimer?.cancel();
        }
      });
    }
  }

  Future<bool> isNeedTimer() async {
    bool needsTimer = false;
    List<String> _prefImgs = await loadPrefImgs();
    /*if(imageCarousel != null) {
      for (ImageCarousel c in imageCarousel!) {
        if(c.taskId != null && c.taskId!.isNotEmpty) {
          needsTimer = true;
          print("TASK FOR: ${c.filename} ${c.taskId}");
          //break;
        }
        if(c.imgBinary != null) {
          //print("${c.filename} HAS BINARY");
        } else {
          print("${c.filename} HAS NULL_BINARY");
        }
      }
    }*/
    if (_prefImgs != null && _prefImgs.length > 0) {
      needsTimer = true;
    }
    print("NEEDSTIMER: $needsTimer");
    return needsTimer;
  }

  Future loadPrefImgs() async {
    print("================= LOAD PREF IMGS =====================");
    List<String> _prefImgs = await Preferences.getListValue("img_task_ids");
    return _prefImgs;
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Preferences.getSharedValue("rpiFail").then((value) {
      if (value == "true") {
        isRPIFail = true;
      } else {
        isRPIFail = false;
      }
    });
    Preferences.setSharedValue("displayMode", "Mode1");
    _heats = [];
    _carousel = [];
    genUrl = LoadContent.baseUri;
    _jobPanels = LoadJobPanel.jobPanels;
    print(genUrl);
    print("----------- JOBPANELS [${_jobPanels}]");

    Preferences.getSharedValue("room").then((val) {
      setState(() {
        String _roomString = val ?? "1";
        confRoomNumber = int.parse(_roomString);
      });
    });
    // getHeats().then((value) {
    //   doneData = [value[0].heatId, value[0].heatDesc];
    //   heatDescDone.add(doneData);
    //   setState(() {
    //     _heats.addAll(value);
    //     heatId = value[0].heatId ?? 0;
    //     heatDescStarted = Text(value[0].heatDesc ?? '',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 76.0, fontFamily: "Times new roman"));
    //     nextHeatId = value[1].heatId ?? 0;
    //     heatDescNext = Text(value[1].heatDesc ?? '',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 26.0, fontFamily: "Times new roman"));
    //     animate = false;
    //   });
    // });

    // getCarousel().then((value) {
    //   setState(() {
    //     _carousel.addAll(value);
    //   });
    // });
    imageCarousel = ImageCarouselConfig.settings;
    getCarousel(imageCarousel);
    //loadPrefImgs().then((value) {
    setCarouselTimer();
    //});

    //game.playerId = '1';
    WebSocketUtil.addListener(
        WebSocketListener('wsNextPage', _onMessageRecieved));

    //game.playerId = '2';
    /*WebSocketUtil.addListener(
        WebSocketListener('wsNextPage2', _onMessageRecieved2));*/

    _initTime(); // initialize time value
    if (dateTime != null) {
      _updateTime();
    }
    getDanceLength();
    setState(() {
      getHeatSequence();
    });
    super.initState();
  }

  _initTime() async {
    //labelTime = DateFormat('h:mm a').format(DateTime.now());
    //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());

    TimeInfo timeInfo = await TimeInfoDao.getTimeInfo();
    setState(() {
      _lastActiveTime = DateTime.now();
      if (timeInfo.toDateTime() != null) {
        dateTime = timeInfo.toDateTime();
        labelTime = DateFormat('h:mm a').format(dateTime!);
      } else {
        labelTime = "";
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (dateTime != null) {
        _updateTime();
      }
      if (DateTime.now().difference(_lastActiveTime!) >
          Duration(minutes: reconnectDelay)) {
        // If idle for more than 5 minutes, perform your action here
        print('User has been idle for more than 3 minutes. reconnecting');
        // reconnect websocket
        game.reactivate();
        _lastActiveTime = DateTime.now();
      }
    });
  }

  _updateTime() {
    if (dateTime != null) {
      setState(() {
        dateTime = dateTime!.add(const Duration(seconds: 1));
        labelTime = DateFormat('h:mm a').format(dateTime!);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /*void _onMessageRecieved2(EntryData e) {
    setState(() {
      if (e.global5 != null) {
        Global5Config.settings!.danceLength = e.global5!.danceLength;
      }
      // Global5Config.settings!.danceLength = e.global5!.danceLength;
      getDanceLength();
      print(e);
    });
  }*/

  void _onMessageRecieved(EntryData e) {
    setState(() {
      _lastActiveTime = DateTime.now();
      if (e.global5 != null) {
        Global5Config.settings!.danceLength = e.global5!.danceLength;
      }
      print("NEXTPAGE executed: override ${e.global6?.mode3Override}");
      print("ROUTE: ${ModalRoute.of(context)?.settings.name}");
      if (e.global6 != null) {
        Global6Config.settings!.mode3Override = e.global6!.mode3Override;
        // show mode3 if true
        if (e.global6!.mode3Override == true) {
          //if(toggle) {
          Navigator.of(context).popUntil(ModalRoute.withName("/nextpage"));
          mod3Test.vidNum = e.global6!.mode3Video;
          Navigator.pushNamed(context, "/mode3test");
          //toggle = false;
          mod3.isActive = true;
        } else {
          bool isMode3 = mod3.isActive;
          if (isMode3) {
            Navigator.maybePop(context);
            mod3.isActive = false;
          }
          //toggle = true;
        }
      }
      getDanceLength();
      getHeatSequence();
      if (e.deviceIdentify != null) {
        print("DEVICE IDENTIFY[${e.deviceIdentify!.set}]");
        bool isOn =
            (e.deviceIdentify!.set != null && e.deviceIdentify!.set == "on")
                ? true
                : false;
        _showOverlay(context, isOn);
      }
      print(e);
    });

    // print("Mess ${e.toMap()}");
    // if (e.started.heatId != doneData[0]) {
    //   print('SAME HEAT ID : ${e.started.heatId}');

    // setState(() {
    //   heatId = e.started.heatId;
    //   nextHeatId = e.started.nextHeatId;

    //   for (var item in _heats) {
    //     if (e.started.heatId == item.heatId) {
    //       descName = item.heatDesc;
    //       heatDescStarted = Text(item.heatDesc ?? '',
    //           textAlign: TextAlign.center,
    //           style:
    //               TextStyle(fontSize: 76.0, fontFamily: "Times new roman"));
    //     }

    //     if (e.started.nextHeatId == item.heatId) {
    //       heatDescNext = Text(item.heatDesc ?? '',
    //           textAlign: TextAlign.center,
    //           style:
    //               TextStyle(fontSize: 26.0, fontFamily: "Times new roman"));
    //     }
    //   }
    //   doneData = [heatId, descName];

    //   // if (heatDescDone[0].contains(doneData[0])) {
    //   //   print('Done Data : ${heatDescDone.contains(doneData)}');
    //   //   return heatDescDone;
    //   // } else {
    //   // print(doneData[0]);

    //   // }
    //   // print('Current Heat : $heatId');

    //   // print('Done Heat : ${heatDescDone[doneSlide][0]}');

    //   // if (heatDescDone[doneSlide][0] != heatId) {
    //   // for (var hdone in heatDescDone) {
    //   //   print('Loop Done : $hdone');
    //   //   if (hdone[0] == doneData[0]) {
    //   //     continue;
    //   //   } else {}
    //   // }
    //   // heatDescDone.removeWhere((value) => value == doneData);
    //   //heatDescDone.add(doneData);

    //   // var distinctIds = heatDescDone.toSet().toList();
    //   // print('DISTINCT : $distinctIds');
    //   // heatDescDone.forEach((e) {
    //   //   if (e == doneData) toRemove.add(e);
    //   //   print('E DATA : $e');
    //   // });
    //   // heatDescDone.removeWhere((e) => toRemove.contains(e));
    //   // print('TO REMOVE : $toRemove');
    //   // print('Done desk $doneData');
    //   print('Heat desk $heatDescDone');

    //   // }
    //   // print(heatDescDone);
    //   // }
    //   // heatDescDone.forEach((element) {
    //   //   print(element[0]);
    //   // });
    //   // heatDescDone.addAll(doneData
    //   //     .where((a) => heatDescDone.every((b) => a.heatId != b.heatId)));

    //   // if (heatDescDone.length > 2) {
    //   //   doneSlide = doneSlide + 1;
    //   // }
    // });
    //}
  }

  // void nextButton() {
  //   setState(() {
  //     doneSlide = doneSlide + 1;
  //     heatSlide = heatSlide + 1;
  //     deckSlide = deckSlide + 1;
  //     percent = 0;
  //     if (doneSlide == _heats.length) {
  //       doneSlide = 1;
  //     }
  //     if (heatSlide == _heats.length) {
  //       heatSlide = 0;
  //     }
  //     if (deckSlide == _heats.length) {
  //       deckSlide = 0;
  //     }
  //   });
  // }

  ///will be called once HeatSequence data from RPI has been updated
  ///
  ///will get Heat's id and desc only
  void getHeatSequence() {
    heatStatus = HeatSequenceConfig.settings!;

    if (heatStatus?.roomNumber != null &&
        heatStatus?.roomNumber != confRoomNumber) {
      return;
    }

    //print("getHeatSequence ==================================");
    print("HEATSTATUS: ${heatStatus?.toMap()}");
    try {
      if (_jobPanels != null) {
        //print("INSIDE IF _jobPanels ==================================");
        //current heat
        if (heatStatus!.currentHeat != null && heatStatus!.currentHeat != 0) {
          //print("INSIDE IF CurrentHeat ==================================");
          heatId = heatStatus!.currentHeat ?? 0;
          //print("heatId [$heatId] ==================================");
          var heatData = _jobPanelData.getHeatData(heatStatus?.currentHeat);
          print("heatData: ${heatData}");
          //HeatDao.getHeatData(heatData.heatId.toString());
          //heatDescStarted = heatData.heatDance;
          heatDescStarted = HeatSequenceConfig.settings!.currentDanceName;
          //print("heatName: ${heatData.heatName}");
          //heatName = heatData.heatName?.toUpperCase();
          heatName = HeatSequenceConfig.settings!.currentHeatNameL1;
          //heatName = heatData.heatName?.toUpperCase().replaceAll("HEAT ", "");
          //print("heatName 1: ${heatName}");
          //heatName = heatName?.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
          //heatName = heatName?.replaceFirst(" ", "\n");
          //print("heatName 2: ${heatName}");
        } else {
          heatId = 0;
          heatDescStarted = null;
        }
        //print("AFTER IF HeatSeq CurrentHeat ==================================");
        //heat status
        bool isStarted = (HeatSequenceConfig.settings!.currentHeatStatus == 2)
            ? true
            : false;
        //heatStarted = isStarted;
        heatStarted = HeatSequenceConfig.settings!.start ?? false;
        //print("AFTER heatStarted ==================================");
        if (!isStarted) {
          _jobPanelData.updateHeatStatus(heatId, isStarted);
        }
        //heat next
        //print("nextHeatId BEFORE IF STATEMENT =========== $nextHeatId");
        if (HeatSequenceConfig.settings?.nextHeat != null &&
            HeatSequenceConfig.settings?.nextHeat != 0) {
          nextHeatId = HeatSequenceConfig.settings?.nextHeat ?? 0;
          //var heatData = _jobPanelData.getHeatData(HeatSequenceConfig.settings?.nextHeat);
          //heatDescNext = heatData.heatDance;
          heatDescNext = HeatSequenceConfig.settings!.nextDanceName;
          //nextHeatName = heatData.heatName?.toUpperCase();
          nextHeatName = HeatSequenceConfig.settings!.nextHeatNameL1;
          //nextHeatName = heatData.heatName?.toUpperCase().replaceAll("HEAT ", "");
          //nextHeatName = nextHeatName?.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
          //nextHeatName = nextHeatName?.replaceFirst(" ", "\n");
        } else {
          nextHeatId = 0;
          heatDescNext = null;
        }
        //print("nextHeatId AFTER IF STATEMENT =========== $nextHeatId");
        //heat done
        if (HeatSequenceConfig.settings?.doneHeat != null &&
            HeatSequenceConfig.settings?.doneHeat != 0) {
          doneHeatId = HeatSequenceConfig.settings?.doneHeat ?? 0;
          //var heatData = _jobPanelData.getHeatData(HeatSequenceConfig.settings?.doneHeat);
          //heatDescDone = heatData.heatDance;
          heatDescDone = HeatSequenceConfig.settings!.doneDanceName;
          //doneHeatName = heatData.heatName?.toUpperCase();
          doneHeatName = HeatSequenceConfig.settings!.doneHeatNameL1;
          //doneHeatName = heatData.heatName?.toUpperCase().replaceAll("HEAT ", "");
          //doneHeatName = doneHeatName?.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
          //doneHeatName = doneHeatName?.replaceFirst(" ", "\n");
        }
        //prevent animation trigger if greenbar is in progress
        if (heatStarted && !isAnimationRunning) {
          //startAnimation();
        }
      }
    } catch (e) {
      print(e.toString());
    }
    //print("heatId: $heatId nextHeatId: $nextHeatId");
    //print("Current: ${HeatSequenceConfig.settings!.currentHeat} Next: ${HeatSequenceConfig.settings?.nextHeat}");
  }

  bool isMulti(String? dataName) {
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    //print("DATANAME: $dataName heatName: $heatName");
    if (heatName.contains(" ")) {
      //print("RETURNED VAL: true");
      return true;
    } else {
      //print("RETURNED VAL: false");
      return false;
    }
  }

  String stripHeatNumber(String? dataName) {
    //print("heatName: ${heatData.heatName}");
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    if (dataName != null && dataName.contains("PRO")) {
      heatName = dataName?.replaceAll("PRO ", "") ?? "";
    }
    //print("heatName 1: ${heatName}");
    if (heatName.contains(" ")) {
      heatName = heatName.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
      heatName = heatName.substring(0, heatName.indexOf(' '));
    }
    //print("heatName 2: ${heatName}");
    return heatName;
  }

  String stripMultiDanceHeat(String? dataName) {
    //print("heatName: ${heatData.heatName}");
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    //print("heatName 1: ${heatName}");
    if (heatName.contains(" ")) {
      heatName = heatName.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
      heatName = heatName.substring(heatName.indexOf(' '), heatName.length);
    }
    //print("heatName 2: ${heatName}");
    return heatName;
  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m").format(now);
  }

  void loadImagesURL() {
    for (var item in _carousel) {
      String imgUrl =
          'http://${genUrl}/uberPlatform/uberdisplay/image/${item.imageId}';
      if (item.enabled) {
        if (item.displayPos != 1) {
          rightSlides.add(Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ));
        } else {
          leftSlides.add(Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ));
        } //item.displayPos end
      } //item.enabled end
    }
  }

  void getDanceLength() {
    try {
      danceLength = Global5Config.settings!.danceLength ?? 0;
      print("DANCELENGTH: $danceLength ================");
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> splitInputString(String mDance, String inp) {
    List<String> parts = [];
    if (inp.isNotEmpty && mDance.contains(inp)) {
      parts = mDance.split(inp);
    }
    //print("part[0]: ${parts[0]}");
    //print("part[1]: ${parts[1]}");
    return parts;
  }

  void _showOverlay(BuildContext context, bool isOn) {
    if (isOn) {
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 10.0, // position from top
          left: 10.0, // position from left
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200, // width of the pop-up
              height: 100, // height of the pop-up
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black, width: 1.5)),
              child: Center(
                  child: Text('${DeviceConfig.deviceName}',
                      style: const TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times new roman"))),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry!);
    } else {
      if (overlayEntry != null) {
        overlayEntry!.remove();
      }
    }

    // Remove the overlay after 3 seconds
    /*Future.delayed(Duration(seconds: 3), () {
      overlayEntry!.remove();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    // print('IMG Url : ${genUrl}');
    //print("HeatStatus: ${heatStatus?.toMap()}");
    heatStarted = heatStatus?.start != null && heatStatus!.start!;
    if (heatStarted) {
      _updateState(stats: true);
    } else {
      _updateState(stats: false);
    }

    String mDance = heatStatus?.currentHeatNameL2 ?? "";
    String inp = heatStatus?.currentDanceShort ?? "";
    List<String> parts = mDance.isNotEmpty ? splitInputString(mDance, "/") : [];
    //print("parts: ${parts}");
    //print("currentHeatNameL1: ${heatStatus?.currentHeatNameL1}");
    List<InlineSpan> itms = [];
    for (int x = 0; x < parts.length; x++) {
      BoxDecoration boxDecoration = BoxDecoration();
      EdgeInsets edgeInsets = const EdgeInsets.only(bottom: 10.0);
      String pText = parts[x];
      if (inp.isNotEmpty && inp.toLowerCase() == parts[x].toLowerCase()) {
        //print("P: ${parts[x]}");
        boxDecoration = BoxDecoration(
          border: Border.all(
              color: Colors.red, width: 10), // This creates the outline
        );
        edgeInsets = const EdgeInsets.symmetric(horizontal: 10, vertical: 1);
      } else {
        if (x + 1 < parts.length) {
          pText += "/";
        }
        if (x > 0 && inp.toLowerCase() == parts[x - 1].toLowerCase()) {
          pText = "/${pText}";
        }
      }
      itms.add(WidgetSpan(
          child: Container(
        padding: edgeInsets,
        decoration: boxDecoration,
        child: Text("${pText}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 60.0,
                fontFamily: "Times new roman")),
      )));
    }

    /*if(parts.isNotEmpty && parts[0].isNotEmpty) {
      itms.add(
        WidgetSpan(
            child: Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(parts[0], style: TextStyle(color: Colors.black, fontSize: 60.0, fontFamily: "Times new roman")),
            )
        )
      );
    }
    if(inp.isNotEmpty) {
      itms.add(
        WidgetSpan(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1), // Adjust padding as needed
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 10), // This creates the outline
            ),
            child: Text("$inp", style: TextStyle(color: Colors.black, fontSize: 60.0, fontFamily: "Times new roman")),
          ),
        )
      );
    }
    if(parts.isNotEmpty && parts[1].isNotEmpty) {
      itms.add(
          WidgetSpan(
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(parts[1], style: TextStyle(color: Colors.black, fontSize: 60.0, fontFamily: "Times new roman")),
              )
          )
      );
    }*/

    Widget richText = RichText(
      text: TextSpan(children: itms),
    );

    String currentHeatNameL1 = heatStatus?.currentHeatNameL1 ?? "";
    if (heatStatus?.currentHeatType != null &&
        heatStatus!.currentHeatType!.isNotEmpty) {
      currentHeatNameL1 += " ${heatStatus?.currentHeatType}";
    }
    //print("currentHeatName: $currentHeatNameL1");
    String doneHeatNameL1 = heatStatus?.doneHeatNameL1 ?? "";
    if (heatStatus?.doneHeatType != null &&
        heatStatus!.doneHeatType!.isNotEmpty) {
      doneHeatNameL1 += " ${heatStatus?.doneHeatType}";
    }
    String nextHeatNameL1 = heatStatus?.nextHeatNameL1 ?? "";
    if (heatStatus?.nextHeatType != null &&
        heatStatus!.nextHeatType!.isNotEmpty) {
      nextHeatNameL1 += " ${heatStatus?.nextHeatType}";
    }

    //print('Dance Length : $danceLength [${dur}]');
    //print("MULTIHEAT: ${isMulti(nextHeatName)}");
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TopBar(
              labelTime: labelTime,
              eventName: (EventConfig.eventName != null && !isRPIFail)
                  ? EventConfig.eventName
                  : "",
            ),
            Expanded(
              flex: 20,
              child: Row(
                children: [
                  BallroomSection(),
                  DoneSection(
                    leftSlides: leftSlides,
                    doneHeatNameL1: doneHeatNameL1,
                    doneHeatNameL2: heatStatus?.doneHeatNameL2,
                    doneDanceName: heatStatus?.doneDanceName,
                  ),
                  HeatSection(
                    currentHeatNameL1: currentHeatNameL1,
                    currentHeatNameL2: heatStatus?.currentHeatNameL2,
                    currentDanceName: heatStatus?.currentDanceName,
                    richText: richText,
                    heatStarted: heatStarted,
                    width: _width,
                    dur: dur,
                  ),
                  OnDeckSection(
                    rightSlides: rightSlides,
                    nextHeatNameL1: nextHeatNameL1,
                    nextHeatNameL2: heatStatus?.nextHeatNameL2,
                    nextDanceName: heatStatus?.nextDanceName,
                  ),
                ],
              ),
            ),
            const BottomBranding(),
          ],
        ),
      ),
    );
  }
}
