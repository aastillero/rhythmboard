// import 'LoadContent.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:uber_display/dao/PiContentDao.dart';
// import 'package:uber_display/dao/LocalContentDao.dart';
// import 'package:uber_display/model/HeatData.dart';
// import 'package:uber_display/mapper/HeatMapper.dart';
// import 'package:uber_display/model/JobPanelData.dart';
// import 'package:uber_display/mapper/JobPanelInfoMapper.dart';
// import 'package:uber_display/mapper/SubHeatMapper.dart';
// import 'package:uber_display/model/HeatCouple.dart';
// import 'package:uber_display/mapper/EntryMapper.dart';
// import 'package:uber_display/util/Preferences.dart';
// import 'package:uber_display/model/config/DeviceConfig.dart';
// import 'package:uber_display/util/ProcessContent.dart';

import 'LoadHeats.dart';

import 'LoadContent.dart';
import 'package:intl/intl.dart';
import '../data/dao/PiContentDao.dart';
import '../data/dao/LocalContentDao.dart';
import '../data/models/HeatData.dart';
import '../data/mapper/HeatMapper.dart';
import '../data/models/JobPanelData.dart';
import '../data/mapper/JobPanelInfoMapper.dart';
import '../data/mapper/SubHeatMapper.dart';
import '../data/models/HeatCouple.dart';
import '../data/mapper/EntryMapper.dart';
import '../utils/Preferences.dart';
import '../data/models/config/DeviceConfig.dart';
import '../utils/ProcessContent.dart';
import '../utils/LogUtil.dart';
import '../websocket/DanceFrameCommunication.dart';

class InitializationUtil {
  static var formatter = new DateFormat("yyyy-MM-dd HH:mm");
  static Stopwatch _watch = Stopwatch();
  static Stopwatch _timer = Stopwatch();

  static Future configureLocalData() async {
    print("CONFIGURING DATA");
    LogUtil.logMessageInfo("Trancating Database", "configureLocalData");
    // truncate data
    await LocalContentDao.truncateDB();

    LogUtil.logMessageInfo("Getting Panel Info", "configureLocalData");
    // load pi_panel_infos
    var panels = await PiContentDao.getAllPanelInfo();

    LogUtil.logMessageInfo("saving jobpanel data", "configureLocalData");
    int panelCnt = 0;
    for (var p in panels) {
      // save job panel
      JobPanelData j = JobPanelInfoMapper.mapFromPanelInfo(p);
      j.panel_order = panelCnt++;
      print("${p["jobPanelDate"]} ${p["jobPanelTime"]}");
      j.time_start =
          formatter.parse("${p["jobPanelDate"]} ${p["jobPanelTime"]}");
      j.time_end = formatter.parse("${p["jobPanelDate"]} ${p["jobPanelTime"]}");
      await LocalContentDao.saveJobPanelData(j);
      // get job panel heats
      var pi_heats = await PiContentDao.getAllHeatsByPanelId(p["jobPanelId"]);
      int heatCnt = 0;
      int? heatStart;
      int? heatEnd;
      for (var h in pi_heats) {
        HeatData heatData = HeatMapper.mapFromPiHeat(h);
        LogUtil.logMessageInfo(
            "Saving Heats: HeatId: ${heatData.id}", "configureLocalData");
        if (heatCnt > 0) {
          //heatStart = int.parse(heatData.id!);
        }
        // heatData.heat_order = heatCnt++;
        // heatData.critique_sheet_type = 2;
        await LocalContentDao.saveHeat(heatData);
        // get all sub heats for particular heat id
        var pi_subheats =
            await PiContentDao.getAllSubHeatsByHeatId(heatData.id);
        for (var sh in pi_subheats) {
          SubHeatData shd = SubHeatMapper.mapFromPiSubHeat(sh);
          //shd.heat_data_id = heatData.id;
          LogUtil.logMessageInfo(
              "Saving SubHeats: SubHeatId: ${shd.id}", "configureLocalData");
          print("VAR SH: $sh");
          await LocalContentDao.saveSubHeat(shd);
          // load entries from subheat
          var pi_entries = await PiContentDao.getAllEntriesBySubHeatId(shd.id);
          print("VAR pi_entries: $pi_entries");
          for (var e in pi_entries) {
            // load couple entry
            var pi_couple =
                await PiContentDao.getCoupleByEntryKey(e["entryKey"]);
            print("pi_couple KEY ${pi_couple["coupleKey"]}");
            // load persons for couple
            var pi_persons = await PiContentDao.getPersonsByCoupleKey(
                pi_couple["coupleKey"]);
            String studio = "";
            HeatCouple hc = EntryMapper.mapFromPiEntry(pi_couple,
                e["subHeatId"], sh["subHeatLevel"], sh["subHeatAge"], studio);
            print("PI_PERSONS LENGTH: ${pi_persons.length}");
            for (var p in pi_persons) {
              Participant cp =
                  EntryMapper.mapFromPiPerson(p, sh["subHeatLevel"]);
              if (studio != "") {
                //hc.participant2 = cp;
              } else {
                //hc.participant1 = cp;
              }
              studio = p["studioName"];
              //await LocalContentDao.saveCouplePerson(cp);
            }
            //print("HC MAP: ${hc.toMap()}");
            LogUtil.logMessageInfo("Saving HeatCouple: HeatCoupleId: ${hc.id}",
                "configureLocalData");
            //await LocalContentDao.saveHeatCouple(hc);
          }
        }

        ///heatEnd = int.parse(heatData.id!);
      }

      if (heatStart != null && heatEnd != null) {
        j.heat_start = heatStart;
        j.heat_end = heatEnd;
      }
      await LocalContentDao.updateJobPanelData(j);
    }
  }

  static Future loadGlobal4Config(resp) async {
    ProcessContent.loadEventPermission(resp["roles"]);
  }

  static Future loadDeviceConfig() async {
    String deviceUID = '';
    String deviceName = '';
    String rpi1;
    String rpi2;
    String? deviceIp;
    String? mask;
    String? primary;
    bool rpi1Enabled = false;
    bool rpi2Enabled = false;

    deviceUID = "${await Preferences.getSharedValue("deviceUID")}";
    deviceName = "${await Preferences.getSharedValue("deviceName")}";
    rpi1 = await Preferences.getSharedValue("rpi1");
    rpi2 = await Preferences.getSharedValue("rpi2");
    deviceIp = await Preferences.getSharedValue("deviceIp");
    mask = await Preferences.getSharedValue("mask");
    primary = await Preferences.getSharedValue("primaryRPI");
    String val = await Preferences.getSharedValue("enabledRPI");
    if (val != null && val.isNotEmpty) {
      List<String> _enabled = [];
      if (val.contains(",")) {
        _enabled = val.split(",");
      } else {
        _enabled.add(val);
      }
      if (_enabled.contains("rpi1")) {
        rpi1Enabled = true;
      }
      if (_enabled.contains("rpi2")) {
        rpi2Enabled = true;
      }
    }
    new DeviceConfig(
        deviceUID: deviceUID,
        deviceIp: deviceIp ?? '',
        deviceName: deviceName,
        mask: mask ?? '',
        primary: primary ?? '',
        rpi1: rpi1,
        rpi2: rpi2,
        rpi1Enabled: rpi1Enabled,
        rpi2Enabled: rpi2Enabled);
    print("DEVICE CONFIG SET: ${DeviceConfig.toMap()}");
  }

  static int getSeconds(milli) {
    Duration dur = Duration(milliseconds: milli);
    return dur.inSeconds;
  }

  static Future initData(context, Function f) async {
    // check if connection status ok
    // clear local pi tables
    // load content from pi
    _watch.reset();
    _timer.reset();
    _watch.start();
    _timer.start();
    await LoadContent.loadUriConfig(f);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadUriConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo("loadUriConfig done", "InitializationUtil-initData");
    _watch.stop();
    print("Elapsed time [loadUriConfig] ${_watch.elapsedMilliseconds}ms");
    _timer.reset();
    _timer.start();
    Function.apply(f, [0.2]);
    var resp = await LoadContent.httpGetData(f);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ initialData: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _watch.stop();
    print("Elapsed time [httpGetData] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _timer.reset();
    _watch.start();
    _timer.start();
    await LoadContent.loadGlobalSixConfig(resp);
    _timer.stop();
    _watch.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadGlobalSixConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    print("Elapsed time [loadGlobal6] ${_watch.elapsedMilliseconds}ms");
    _timer.reset();
    _timer.start();
    await loadDeviceConfig();
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadDeviceConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo(
        "loadDeviceConfig done", "InitializationUtil-initData");
    _watch.stop();
    print("Elapsed time [loadDeviceConfig] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _timer.reset();
    _watch.start();
    _timer.start();
    var conn = await LoadContent.loadEventConfig(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _watch.stop();
    print("Elapsed time [loadEventConfig] ${_watch.elapsedMilliseconds}ms");

    if (conn != null) {
      if (conn == "connectionFailure") {
        return conn;
      }
    }
    _watch.reset();
    _timer.reset();
    _watch.start();
    _timer.start();
    await loadGlobal4Config(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadGlobal4Config: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo(
        "loadGlobal4Config done", "InitializationUtil-initData");
    _watch.stop();
    print("Elapsed time [loadGlobal4Config] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _timer.reset();
    _watch.start();
    _timer.start();
    await LoadContent.loadGlobalFiveConfig(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadGlobalFiveConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo(
        "loadGlobalFiveConfig done", "InitializationUtil-initData");
    _watch.stop();
    print("Elapsed time [loadGlobal5Config] ${_watch.elapsedMilliseconds}ms");
    _watch.stop();
    _timer.reset();
    _timer.start();
    _watch.start();
    await LoadContent.loadGlobalSevenConfig(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadGlobalSevenConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _watch.stop();
    print("Elapsed time [loadGlobal7Config] ${_watch.elapsedMilliseconds}ms");
    _watch.stop();
    _timer.reset();
    _timer.start();
    _watch.start();
    await LoadContent.loadHeatSequence(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadHeatSequence: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _watch.stop();
    print("Elapsed time [loadHeatSequence] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _timer.reset();
    _timer.start();
    _watch.start();
    await LoadContent.loadTimeoutConfig(resp);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadTimeoutConfig: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo(
        "loadTimeoutConfig done", "InitializationUtil-initData");
    _watch.stop();
    print("Elapsed time [loadTimeoutConfig] ${_watch.elapsedMilliseconds}ms");
    //String deviceNum = await Preferences.getSharedValue("deviceNumber");
    //print("GETTING DEVICE NUMBER: $deviceNum");
    /*if(deviceNum != null && deviceNum.isNotEmpty) {
      //await LoadContent.loadDeviceConfig(context, deviceNum);
    }*/
    _watch.reset();
    _watch.start();
    _timer.reset();
    _timer.start();
    Function.apply(f, [0.1]);
    await LoadContent.loadEventData(resp, f);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadEventData: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _watch.stop();
    print("Elapsed time [loadEventData] ${_watch.elapsedMilliseconds}ms");
    //_watch.reset();
    // _watch.start();
    // await LoadContent.loadJudge(resp);
    // _watch.stop();
    // print("Elapsed time [loadTimeoutConfig] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _watch.start();
    //TODO
    //await LoadContent.loadCritiques(resp);
    _watch.stop();
    print("Elapsed time [loadTimeoutConfig] ${_watch.elapsedMilliseconds}ms");
    _watch.reset();
    _watch.start();
    //TODO
    //await LoadContent.loadProfRank(resp);
    print("Elapsed time [loadTimeoutConfig] ${_watch.elapsedMilliseconds}ms");
    _watch.stop();
    // configure device data reflecting data from pi tables
    //await configureLocalData();
    //await LocalContentDao.selectHeatCouple(28);
    //await LoadJobPanel.initJobPanelList();
    _timer.reset();
    _timer.start();
    Function.apply(f, [0.1]);
    await LoadContent.loadImageCarousel();
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ loadImageCarousel: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    LogUtil.logMessageInfo(
        "loadImageCarousel done", "InitializationUtil-initData");
    _timer.reset();
    _timer.start();
    //await LoadHeats.initHeats();
    Function.apply(f, [0.1]);
    await LoadHeats.initializeHeats(resp);
    _timer.stop();
    //print("▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ LoadHeats.initHeats: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ LoadHeats.initializeHeats: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    //initialize websocket connection
    print("Initializing Websocket");
    _timer.reset();
    _timer.start();
    await game.initializeSocket();
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ game.initializeSocket: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
  }
}
