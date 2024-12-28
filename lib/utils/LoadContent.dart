import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../data/models/ImageCarousel.dart';
import '../data/models/config/ImageCarouselConfig.dart';
import '../data/models//config/TimeOutConfig.dart';
import 'FileUtil.dart';
import 'HttpUtil.dart';
import '../data/dao/PiContentDao.dart';
import 'Preferences.dart';
import '../data/models/config/EventConfig.dart';
import '../data/models/config/DeviceConfig.dart';
import 'ProcessContent.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'DeviceUtil.dart';
import 'package:path_provider/path_provider.dart';

class LoadContent {
  static String? baseUri;
  static String? baseUri2;
  static String protocol = "http://";
  static String safeProtocol = "https://";
  static bool connectionFailure = false;
  static Stopwatch _watch = Stopwatch();
  static Stopwatch _timer = Stopwatch();

  static String strippedDownUrl(String uri) {
    String retVal = "";
    retVal = uri.replaceAll("http://", "");
    retVal = retVal.replaceAll("http://", "");
    return retVal;
  }

  static loadUriConfig(Function f) async {
    //String confValue = await ConfigUtil.getConfig("app_local_server");
    // get baseUri by getting primaryURI
    String primaryRPI = await Preferences.getSharedValue("primaryRPI");
    String rpiEnabled = await Preferences.getSharedValue("enabledRPI");
    if (primaryRPI != null && primaryRPI.isNotEmpty) {
      baseUri = await Preferences.getSharedValue(primaryRPI);
      baseUri = strippedDownUrl(baseUri ?? '');
      Function.apply(f, [0.05]);
    }
    if (rpiEnabled != null && rpiEnabled.contains(",")) {
      List<String> _enabledArr = rpiEnabled.split(",");
      for (String s in _enabledArr) {
        if (s != primaryRPI) {
          baseUri2 = await Preferences.getSharedValue(s);
          baseUri2 = strippedDownUrl(baseUri2 ?? '');
          Function.apply(f, [0.05]);
        }
      }
    }
  }

  // static Future loadEventPermission(context) async {
  //   var resp = await httpRequest("/uberPlatform/config/rolematrix/", context);
  //   print('test $resp');
  //   List<JobPanel> jobPanelList = [];
  //   if (isSuccess(resp)) {
  //     for (var m in resp) {
  //       JobPanel jobpanel = new JobPanel.fromMap(m);
  //       jobPanelList.add(jobpanel);
  //     }
  //     return jobPanelList;
  //   } else {
  //     return await handleConnectionError(context);
  //   }
  // }

  // static Future saveEventPermission(context, JobPanel jP) async {
  //   Map reqBody = jP.toMap();
  //   print(protocol + baseUri + "/uberPlatform/config/rolematrix/input");
  //   var resp = await HttpUtil.postRequest(context,
  //       protocol + baseUri + "/uberPlatform/config/rolematrix/input", reqBody);
  // }

  static bool isSuccess(resp) {
    bool retVal = false;
    if (resp != null) {
      print("resp is list: ${resp is List}");
      if (resp is List) {
        retVal = true;
      } else if (resp["error"] == null) {
        print("resp[error] = ${resp["error"]}");
        retVal = true;
      }
    }
    print("isERROR = $retVal");
    return retVal;
  }

  static Future handleConnectionError() async {
    // await ScreenUtil.showMainFrameDialog(
    //     context, "Error Connecting", "Could not connect to servers.");
    return "connectionFailure";
  }

  static loadEventConfig(resp) async {
    /*var resp = await httpRequest("/uberPlatform/config/event/info", context);
    print("RESP: $resp");
    if (isSuccess(resp)) {
      EventConfig conf = new EventConfig(resp["eventName"],
          "${resp["eventDate"]} ${resp["eventTime"]}", resp["screenTimeout"]);
      print("EVENT CONFIG EventName: ${EventConfig.eventName}");
      print("EVENT CONFIG EventDate: ${EventConfig.eventDate}");
      print("EVENT CONFIG EventYear: ${EventConfig.eventYear}");
      print("EVENT CONFIG EventTime: ${EventConfig.eventTime}");
    } else {
      return await handleConnectionError(context);
    }*/
    return await ProcessContent.loadEventConfig(resp["eventInfo"]);
  }

  static loadGlobalFiveConfig(resp) async {
    return await ProcessContent.loadGlobalFiveConfig(resp["globalfive"]);
  }

  static loadGlobalSixConfig(resp) async {
    return await ProcessContent.loadGlobalSixConfig(resp["globalsix"]);
  }

  static loadGlobalSevenConfig(resp) async {
    return await ProcessContent.loadGlobalSevenConfig(resp["globalseven"]);
  }

  static loadHeatSequence(resp) async {
    return await ProcessContent.loadHeatSequenceConfig(resp["heatStatus"]);
  }

  static loadDeviceConfig(context, deviceUID) async {
    var resp = await httpRequest("/uberPlatform/device/info/$deviceUID");
    if (isSuccess(resp)) {
      // DeviceConfig conf = new DeviceConfig();
      DeviceConfig.deviceUID = resp["deviceUID"];
      DeviceConfig.deviceName = resp["deviceName"];
      DeviceConfig.deviceIp = resp["deviceIp"];
      DeviceConfig.mask = resp["mask"];
      DeviceConfig.rpi1 = resp["rpi1"];
      DeviceConfig.rpi2 = resp["rpi2"];
      DeviceConfig.rpi1Enabled =
          resp["rpi1Enabled"].toString().toLowerCase() == 'true';
      DeviceConfig.rpi2Enabled =
          resp["rpi2Enabled"].toString().toLowerCase() == 'true';
      DeviceConfig.primary = resp["primary"];
    }
  }

  static Future testConnection(stringUri) async {
    var resp = await HttpUtil.getRequest(protocol + stringUri);
    if (isSuccess(resp)) {
      return resp;
    }
  }

  // static Future uberDisplayImgUrl(context, imgUrl) async {
  //   var resp =
  //       await httpRequest('/uberPlatform/uberdisplay/image/$imgUrl', context);
  //   if (isSuccess(resp)) {
  //     return resp;
  //   }
  // }

  static loadTimeoutConfig(resp) async {
    /*var resp = await httpRequest("/uberPlatform/config/timeouts", context);
    if (resp != null) {
      for (var i = 0; i < resp.length; i++) {
        print(resp[i]["jobType"]);
        //store
        Preferences.setSharedValue(
            resp[i]["jobType"],
            "enabled:" +
                resp[i]["enabled"].toString() +
                ",timeoutVal:" +
                resp[i]["timeoutVal"].toString());
      }
      print("EVENT CONFIG EventName: ${EventConfig.eventName}");
      print("EVENT CONFIG EventDate: ${EventConfig.eventDate}");
      print("EVENT CONFIG EventYear: ${EventConfig.eventYear}");
      print("EVENT CONFIG EventTime: ${EventConfig.eventTime}");
    }*/
    ProcessContent.loadTimeoutConfig(resp["timeouts"]);
  }

  static Future<File?> getImageFile(String? filename) async {
    if (filename == null || filename.isEmpty) {
      return null;
    }
    // Encode the filename to handle spaces and special characters
    String encodedFilename = Uri.encodeFull(filename);

    // Get the image file using the encoded filename
    File? imageFile = await FileUtil.getImageFile(encodedFilename);

    return imageFile;
  }

  static Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;

    return externalStorageDirPath;
  }

  static Future<String?> _initImageDownload(filename, uri) async {
    String localPath = (await _getSavedDir())!;
    print("LOCAL PATH: $localPath");

    String? taskId = await FlutterDownloader.enqueue(
        url: uri,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: localPath,
        showNotification:
            false, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        //saveInPublicStorage: true,
        fileName: filename);
    if (taskId != null) {
      print("$filename >>>>>>>>> IMAGE TASK ID[$taskId]");
      _setImagesPref(taskId);
    }
    return taskId;
  }

  static _setImagesPref(taskId) async {
    String key = "img_task_ids";
    List<String> imgTasks = await Preferences.getListValue(key);
    if (imgTasks.contains(taskId)) {
      // already present
    } else {
      imgTasks.add(taskId);
      Preferences.setListValue(key, imgTasks);
    }
  }

  static reloadImageCarousel(id) async {
    List<ImageCarousel> imageCarousels = ImageCarouselConfig.settings ?? [];
    String fileName = "";
    for (ImageCarousel temp in imageCarousels) {
      if (temp.taskId == id) {
        File? imgFile = await getImageFile(temp.filename);
        fileName = temp.filename ?? "";
        if (imgFile != null) {
          //img already saved, pass it into temp
          print('Getting binary data of ${temp.filename} from local storage');
          temp.imgBinary = imgFile.readAsBytesSync();
          temp.taskId = null;
          break;
        } else {
          print("IMG FILE IS NULL: $fileName");
        }
      }
    }
    if (imageCarousels.length > 0) {
      ImageCarouselConfig(imageCarousel: imageCarousels);
    }
    print("Carousel reloaded [$fileName] [$id]");
  }

  static reloadCarousel() async {
    List<ImageCarousel> imageCarousels = ImageCarouselConfig.settings ?? [];
    for (ImageCarousel temp in imageCarousels) {
      File? imgFile = await getImageFile(temp.filename);
      if (imgFile != null) {
        //img already saved, pass it into temp
        //print('Getting binary data of ${temp.filename} from local storage');
        temp.imgBinary = imgFile.readAsBytesSync();
        print("Carousel reloaded [${temp.filename}]");
      }
    }
    if (imageCarousels.length > 0) {
      ImageCarouselConfig(imageCarousel: imageCarousels);
    }
  }

  static Future loadImageCarousel() async {
    Preferences.setListValue("img_task_ids", []);
    List<ImageCarousel>? imageCarousels = [];
    //get list of Image data
    print('Requesting for image data');
    List<dynamic>? resp = await HttpUtil.getImgRequest(protocol +
        (baseUri ?? '') +
        "/uberPlatform/uberdisplay/image/info/all");

    if (resp != null && resp.length > 0) {
      print('Response Load Image $resp');
      //loop each data for verification
      for (var i = 0; i < resp.length; i++) {
        ImageCarousel? temp = ImageCarousel.fromMap(resp[i]);
        if (temp != null) {
          //get image in local
          //File? imgFile = await FileUtil.getImageFile(temp.filename);
          File? imgFile = await getImageFile(temp.filename);
          //verify if image is already been saved
          if (imgFile != null) {
            //img already saved, pass it into temp
            print('Getting binary data of ${temp.filename} from local storage');
            temp.imgBinary = imgFile.readAsBytesSync();
          } else {
            //proceed with saving
            //request for the binary image
            print('Requesting for binary data of ${temp.filename}');

            var url = protocol +
                (baseUri ?? '') +
                "/uberPlatform/uberdisplay/image/${temp.id}";

            //var imageBinary = await HttpUtil.getImgRequest(url);
            //-UPD4TE-
            //Using from previous build
            //var imageBinary = await HttpUtil.getRequest(url);
            String? taskId = await _initImageDownload(temp.filename, url);
            temp.taskId = taskId;

            print("Temp ${temp}");
            // print(protocol +
            //     (baseUri ?? '') +
            //     "/uberPlatform/uberdisplay/image/${temp.id}");
            //save the binary as img
            // print('Saving binary data of ${temp.filename} to local storage');

            //await FileUtil.saveFile(imageBinary, temp.filename!);

            //temp.imgBinary = imageBinary ?? [];
            //-UPD4TE-
            //Fixed ISSUE UIntList is not List<dynamic>
            //temp.imgBinary = imageBinary;
          }
          imageCarousels.add(temp);
        }
      }
    }
    if (imageCarousels.length > 0) {
      ImageCarouselConfig(imageCarousel: imageCarousels);
    }
  }

  static Future saveEventConfig(context) async {
    Map reqBody = EventConfig.toMap();
    print(protocol + (baseUri ?? '') + "/uberPlatform/config/event/input");
    var resp = await HttpUtil.postRequest(
        protocol + (baseUri ?? '') + "/uberPlatform/config/event/input",
        reqBody);
  }

  static Future<bool> saveTimeoutConfig(context) async {
    try {
      // var i = 100 ~/ 0;
      // print("$i");
    } on Exception catch (e) {
      print('saveTimeoutConfig error : $e');
      FlutterLogs.logThis(
          tag: 'MyApp',
          subTag: 'Caught an exception.',
          logMessage: 'Caught an exception!',
          exception: e,
          level: LogLevel.ERROR);
    }
    var reqBody = TimeOutConfig().toMap();
    if (protocol == null || baseUri == null) {
      return false;
    } else {
      // print(protocol + (baseUri ?? '') + "/uberPlatform/config/timeout/input");
      // print(reqBody);
      await HttpUtil.postRequest(
          protocol + (baseUri ?? '') + "/uberPlatform/config/timeout/input",
          reqBody);
      return true;
    }
  }

  // static Future saveDeviceConfig(context) async {
  //   Map reqBody = DeviceConfig.toMap();

  //   var resp = await HttpUtil.postRequest(
  //           context,
  //           protocol + (baseUri ?? '') + '/uberPlatform/device/info/input',
  //           reqBody)
  //       .toString();
  // }

  static Future saveDeviceConfig(context) async {
    FlutterLogs.logThis(
        tag: 'MyApp',
        subTag: 'logData',
        logMessage:
            'This is a log message: ${DateTime.now().millisecondsSinceEpoch}',
        level: LogLevel.INFO);

    Map reqBody = DeviceConfig.toMap();
    String uid = await DeviceUtil.getDeviceId();
    reqBody.putIfAbsent("deviceUID", () => uid);
    print('Protocol : ${protocol}');
    print('BaseUri : ${baseUri}');
    print('ReqBody :${reqBody}');
    var resp = await HttpUtil.postRequest(
        // protocol + baseUri! + "/uberPlatform/device/info/input", reqBody); -- deprecated
        protocol + baseUri! + "/uberPlatform/cache/device/info/uid/input",
        reqBody);
  }

  static Future httpRequest(String uri,
      {bool withoutBaseUri = false, bool requestOnce = false}) async {
    print("URI: $uri");
    String requestUri = (withoutBaseUri == null || !withoutBaseUri)
        ? protocol + baseUri! + uri
        : protocol + uri;
    print("REQUEST: ${requestUri} || withoutBaseUri: $withoutBaseUri");
    var resp = await HttpUtil.getRequest(requestUri);
    print("RESPONSE: $resp");
    int retryCount = (requestOnce != null && requestOnce) ? 5 : 0;
    bool isUri2 = false;
    bool invalidResponse = false;

    do {
      if (resp is List) {
        print("LIST OBJECT");
      } else {
        if (resp.containsKey("error")) {
          invalidResponse = true;
        }
      }

      if (invalidResponse) {
        if (retryCount < 5) {
          // error has occurred retry request
          if (!isUri2) {
            print("requesting uri: ${requestUri}");
            resp = await HttpUtil.getRequest(requestUri);
          } else {
            requestUri = (withoutBaseUri == null || !withoutBaseUri)
                ? protocol + baseUri2! + uri
                : protocol + uri;
            print("requesting uri2: ${requestUri}");
            resp = await HttpUtil.getRequest(requestUri);
          }
          retryCount += 1;
        } else {
          retryCount = 0;
          if (!isUri2 && (baseUri2 != null && baseUri2!.isNotEmpty)) {
            isUri2 = true;
          } else {
            isUri2 = false;
            print("Could not connect to RPI servers.");
            //await Preferences.setSharedValue("deviceNumber", null);
            //await Preferences.setSharedValue("rpi1", null);
            //await Preferences.setSharedValue("rpi2", null);
            break;
          }
        }
      }
    } while (invalidResponse);

    return resp;
  }

  static Future cleanPiTables() async {
    return PiContentDao.truncateTables();
  }

  static Future sendCritique(context, Map<String, dynamic> reqBody) async {
    var resp = await HttpUtil.postRequest(
        protocol + (baseUri ?? '') + "/uberPlatform/critique/input", reqBody);
  }

  static Future uploadImg(context, file) async {
    var resp = await HttpUtil.uploadImage(
        context, protocol + (baseUri ?? '') + "/uberPlatform/upload", file);
    // return image upload ID
    if (resp != null && resp["uploadId"] != null) {
      return resp["uploadId"];
    } else {
      return null;
    }
  }

  static Future saveJudgeInitials(context, Map<String, dynamic> reqBody) async {
    var resp = await HttpUtil.postRequest(
        protocol + (baseUri ?? '') + "/uberPlatform/people/initials/input",
        reqBody);
  }

  // static Future loadHeatInfoById(id, peopleId, context) async {
  //   //var resp = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/heat/id/$id");
  //   var resp = await httpRequest("/uberPlatform/heat/id/$id", context);
  //   HeatInfo info;
  //   if (isSuccess(resp)) {
  //     print("LENGTH: ${resp.length}");
  //     info = new HeatInfo();
  //     info.id = resp["heatId"].toString();
  //     info.heat_number = resp["heatName"];
  //     info.heat_title = resp["heatDesc"];
  //     info.critiqueSheetType = 2;
  //     info.judge = peopleId;
  //     if (info.danceSubheatLevels == null) {
  //       info.danceSubheatLevels = [];
  //     }
  //     // traverse sub heats
  //     if (resp["subheats"] != null) {
  //       for (var sh in resp["subheats"]) {
  //         if (sh["entries"] != null) {
  //           for (var e in sh["entries"]) {
  //             if (e["peopleId"] != null &&
  //                 e["peopleId"] == int.parse(peopleId)) {
  //               // found entry
  //               if (info.assignedCouple == null) info.assignedCouple = [];

  //               // get subheat Level
  //               info.danceSubheatLevels.add(sh["subHeatlevel"]);
  //               info.assignedCouple.add(e["entryKey"]);
  //             }
  //             if (e["entryId"] != null) {
  //               if (info.entries == null) info.entries = [];

  //               info.entries.add(e["entryId"]);
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return info;
  // }

  static Future loadJobPanelInfo(context) async {
    //var resp = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/panel/info");
    var resp = await httpRequest("/uberPlatform/cache/panel/info");
    if (isSuccess(resp)) {
      print("LENGTH: ${resp.length}");
      await PiContentDao.saveAllPanelInfo(resp);
      await PiContentDao.getAllPanelInfo();
    }
    return resp;
  }

  /*static Future loadPeople() async {
    //var resp = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/people/info");
    var resp = await httpRequest("/uberPlatform/cache/people/info");
    print("LENGTH: ${resp.length}");
    if (isSuccess(resp)) {
      for (var p in resp) {
        int? peopleId = await PiContentDao.savePeople(p);
        for (var a in p["assignments"]) {
          /*String _role = "";
        switch(a["role"]) {
          case "JUDGE":
        }*/
          int? assignmentId = await PiContentDao.saveAssignment(a, peopleId);
        }
      }
    }
    return resp;
  }*/

  //static Future loadCouples(entryKey) async {
  static Future loadCouples(context) async {
    print("LOADING ALL COUPLES");
    //var c = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/heat/couple/key/${entryKey}");
    //var resp = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/heat/couples");
    var resp = await httpRequest("/uberPlatform/cache/heat/couples");
    print("LENGTH: ${resp.length}");
    if (isSuccess(resp)) {
      for (var c in resp) {
        //if(c != null && c["coupleId"] != null) {
        //var couple_key = await PiContentDao.saveCouple(c);
        // save persons
        for (var p in c["persons"]) {
          await PiContentDao.savePerson(p, c["coupleKey"]);
        }
      }
    }
    return resp;
  }

  static Future loadAllHeatsByPanelId(id, context) async {
    print("LOADING ALL HEATS in ID[${id}]");
    //var resp = await HttpUtil.getRequest(protocol+ baseUri + "/uberPlatform/heat/panel/id/${id}");
    var resp = await httpRequest("/uberPlatform/cache/panel/id/${id}");
    int heatCnt = 0;
    if (isSuccess(resp)) {
      for (var h in resp["heats"]) {
        int subCnt = 0;
        int entryCnt = 0;
        //await PiContentDao.saveHeat(h);
        heatCnt += 1;
        // save sub heats
        for (var s in h["subheats"]) {
          //await PiContentDao.saveSubHeat(s);
          //subCnt += 1;
          // save entries
          for (var e in s["entries"]) {
            //await PiContentDao.saveEntry(e, s["subHeatId"], s["heatId"]);
            //entryCnt += 1;
            //await loadCouples(e["entryKey"]);
          }
        }
        //print("SUB HEATS: [$subCnt]");
        //print("ENTRIES: [$entryCnt]");
      }
    }
    print("HEATS: [$heatCnt]");
    //print("LENGTH: ${resp["heats"]?.length}");
  }

  static Future httpGetData(Function f) async {
    Function.apply(f, [0.05]);
    _watch.reset();
    _watch.start();
    //var resp = await httpRequest("/uberPlatform/cache/initialdata");
    var resp = await httpRequest("/uberPlatform/v2/initialdata");
    _watch.stop();
    print("Elapsed time [initialData Request] ${_watch.elapsedMilliseconds}ms");
    if (isSuccess(resp)) {
      return resp;
    } else {
      return await handleConnectionError();
    }
  }

  static Future loadAllData(resp) async {
    // if (resp["panels"] != null) {
    //   _watch.reset();
    //   _watch.start();
    //   await ProcessContent.saveAllJobPanels(resp["panels"], f);
    //   _watch.stop();
    //   print("Elapsed time [saveAllJobPanels] ${_watch.elapsedMilliseconds}ms");
    // }
    // if (resp["couples"] != null) {
    //   print("COUPLES LENGTH: ${resp["couples"].length}");
    //   _watch.reset();
    //   _watch.start();
    //   await ProcessContent.saveAllCouples(resp["couples"]);
    //   _watch.stop();
    //   print("Elapsed time [saveAllCouples] ${_watch.elapsedMilliseconds}ms");
    //   Function.apply(f, [0.1]);
    // }
    // if (resp["persons"] != null) {
    //   List<dynamic> persons = resp["persons"];
    //   print("PERSONS LENGTH: ${persons.length}");
    //   _watch.reset();
    //   _watch.start();
    //   await ProcessContent.saveSoloPersons(persons);
    //   _watch.stop();
    //   print("Elapsed time [saveSoloPersons] ${_watch.elapsedMilliseconds}ms");
    //   Function.apply(f, [0.1]);
    // }
    // if (resp["peoples"] != null) {
    //   print("PEOPLE LENGTH: ${resp["peoples"].length}");
    //   _watch.reset();
    //   _watch.start();
    //   await ProcessContent.saveAllPeople(resp["peoples"]);
    //   _watch.stop();
    //   print("Elapsed time [saveAllPeople] ${_watch.elapsedMilliseconds}ms");
    //   Function.apply(f, [0.1]);
    // }
    // ---------------- non Batch
    /*if(resp["heats"] != null) {
      await ProcessContent.processSavingResponseData(
          resp["heats"], PiContentDao.saveHeat, "Heat");
    }
    if(resp["subheats"] != null) {
      await ProcessContent.processSavingResponseData(
          resp["subheats"], PiContentDao.saveSubHeat, "SubHeats");
    }
    if(resp["entries"] != null) {
      await ProcessContent.processSavingResponseData(
          resp["entries"], PiContentDao.saveEntry, "Entries");
    }
    if(resp["couples"] != null) {
      await ProcessContent.processSavingResponseData(
          resp["couples"], PiContentDao.saveCouple, "Couples");
    }
    if(resp["persons"] != null) {
      await ProcessContent.processSavingResponseData(
          resp["persons"], PiContentDao.savePerson, "Persons");
    }*/
    // ------------- Batch
    if (resp["heats"] != null) {
      await ProcessContent.processSavingResponseData2(
          resp["heats"], PiContentDao.batchHeat, "Heat");
    }
    if (resp["subheats"] != null) {
      await ProcessContent.processSavingResponseData2(
          resp["subheats"], PiContentDao.batchSubHeat, "SubHeats");
    }
    if (resp["entries"] != null) {
      await ProcessContent.processSavingResponseData2(
          resp["entries"], PiContentDao.batchEntry, "Entries");
    }
    if (resp["couples"] != null) {
      await ProcessContent.processSavingResponseData2(
          resp["couples"], PiContentDao.batchCouple, "Couples");
    }
    if (resp["persons"] != null) {
      await ProcessContent.processSavingResponseData2(
          resp["persons"], PiContentDao.batchPerson, "Persons");
    }
  }

  static int getSeconds(milli) {
    Duration dur = Duration(milliseconds: milli);
    return dur.inSeconds;
  }

  static Future loadEventData(resp, Function f) async {
    // load all job panel
    _timer.reset();
    _timer.start();
    await cleanPiTables();
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventData[cleanPiTables]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    Function.apply(f, [0.05]);
    //processing data from endpoint url
    _timer.reset();
    _timer.start();
    //await ProcessContent.processCompetitionData(f);
    await loadAllData(resp);
    _timer.stop();
    //print("▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventData[processCompetitionData]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventData[loadAllData]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    if (resp["peoples"] != null) {
      _timer.reset();
      _timer.start();
      await ProcessContent.processPeopleData(resp["peoples"], f);
      _timer.stop();
      print(
          "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventData[processPeopleData]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    }
    if (resp["studios"] != null) {
      //await ProcessContent.processStudio(resp["studios"], f);
    }
    /*var panels = await loadJobPanelInfo(context);
    if (panels.length > 0) {
      loadDivision = 0.6 / panels.length;
    }
    for (var p in panels) {
      await loadAllHeatsByPanelId(p["jobPanelId"], context);
      Function.apply(f, [loadDivision]);
    }

    if (panels.length <= 0) Function.apply(f, [0.6]);
    //await PiContentDao.getAllHeats();
    // load all couples
    await loadCouples(context);
    Function.apply(f, [0.1]);
    //await PiContentDao.getAllCouples();
    await PiContentDao.getAllPersons();
    // load pi people
    await loadPeople(context);
    Function.apply(f, [0.1]);
    //await PiContentDao.getAllPeople();
    //await PiContentDao.getAllAssignments();
    */
  }
}
