import '../data/models/enums/UserProfiles.dart';
import '../data/models/enums/AcessPermissions.dart';
import '../data/models/HeatSequence.dart';
import '../data/models/JobPanel.dart';
import '../data/models/config/EventConfig.dart';
import '../data/models/config/Global4Config.dart';
import '../data/models/Global5.dart';
import '../data/models/config/Global5Config.dart';
import '../data/dao/PiContentDao.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/config/HeatSequenceConfig.dart';
import '../utils/AppConst.dart';
import '../utils/DatabaseHelper.dart';
import '../utils/Preferences.dart';
import '../utils/LoadContent.dart';
import '../data/models/config/Global7Config.dart';
import '../data/models/config/Global6Config.dart';
import '../data/models/Global7.dart';
import '../data/models/Global6.dart';

class ProcessContent {
  static Future _saveAllPanelInfo(panelInfo) async {
    Database db = await DatabaseHelper.instance.database;
    for (var p in panelInfo) {
      int id = await db.insert("pi_panel_info", {
        //temporary set specific id
        "jobPanelId": 1,
        //"jobPanelId": p["panelId"],
        "jobPanelTime": p["panelTime"],
        "jobPanelDate": p["panelDate"],
        "jobSession": p["panelSession"]
      });
    }
  }

  static Future _saveHeat(h, Batch? b) async {
    //Database db = await DatabaseHelper.instance.database;
    b!.insert("pi_heat", {
      "heatId": h["heatId"],
      "heatName": h["heatName"],
      "heatSession": h["heatSession"],
      "heatTime": h["heatTime"],
      "heatDesc": h["heatDesc"],
      "heatDance": h["heatDance"],
      //temporary set specific id
      "panelId": 1,
      //"panelId": h["panelId"],
      "is_started": h["heatStatus"],
    });
  }

  static Future _saveSubHeat(s, Batch? b) async {
    //Database db = await DatabaseHelper.instance.database;
    b?.insert("pi_sub_heat", {
      "subHeatId": s["subHeatId"],
      "sequenceId": s["sequenceId"],
      "subHeatType": s["subHeatType"],
      "subHeatDance": s["subHeatdance"],
      "subHeatLevel": s["subHeatlevel"],
      "subHeatAge": s["subHeatAge"],
      "heatId": s["heatId"],
    });
  }

  static Future _saveEntry(e, subHeatId, heatId, Batch? b) async {
    b?.insert("pi_entry", {
      "entryId": e["entryId"],
      "entryKey": e["entryKey"],
      "entryType": e["entryType"],
      "status": e["status"],
      "peopleId": e["peopleId"],
      "judgeNum": e["judgeNum"],
      "subSeqId": e["subSeqId"],
      "studioName": e["studioName"],
      "studioKey": e["studioKey"],
      "subHeatId": subHeatId,
      "heatId": heatId,
    });
    //print("ENTRY SAVED ID[$id], SUB HEAT ID: [$subHeatId]");
  }

  static Future loadEventConfig(e) async {
    EventConfig conf = new EventConfig(e["eventName"],
        "${e["eventDate"]} ${e["eventTime"]}", e["screenTimeout"]);
    print("EVENT CONFIG EventName: ${EventConfig.eventName}");
    print("EVENT CONFIG EventDate: ${EventConfig.eventDate}");
    print("EVENT CONFIG EventYear: ${EventConfig.eventYear}");
    print("EVENT CONFIG EventTime: ${EventConfig.eventTime}");
  }

  static loadTimeoutConfig(e) async {
    for (var i = 0; i < e.length; i++) {
      print(e[i]["jobType"]);
      //store
      Preferences.setSharedValue(
          e[i]["jobType"],
          "enabled:" +
              e[i]["enabled"].toString() +
              ",timeoutVal:" +
              e[i]["timeoutVal"].toString());
    }
  }

  static Future loadHeatSequenceConfig(e) async {
    // print('Process Content Global5 Desc : ${e['heatDescription']}');
    // print('Process Content Global5 Sel : ${e['heatSelection']}');
    print("LOADING HEAT SEQUENCE: $e");
    HeatSequence seq = HeatSequence.fromMap(e);
    HeatSequenceConfig(heatSequence: seq);
  }

  static Future loadEventPermission(e) async {
    List<JobPanel> jobPanelList = [];
    for (var m in e) {
      JobPanel _jobpanel = new JobPanel.fromMap(m);
      jobPanelList.add(_jobpanel);
    }
    Map<AccessPermissions, List<UserProfiles>> rolePermissions = {};
    for (var jp in jobPanelList) {
      List<UserProfiles> _tempAccess = [];
      if (jp.judge) {
        _tempAccess.add(UserProfiles.JUDGE);
      }
      if (jp.scrutineer) {
        _tempAccess.add(UserProfiles.SCRUTINEER);
      }
      if (jp.emcee) {
        _tempAccess.add(UserProfiles.EMCEE);
      }
      if (jp.chairman) {
        _tempAccess.add(UserProfiles.CHAIRMAN_OF_JUDGES);
      }
      if (jp.deck) {
        _tempAccess.add(UserProfiles.DECK_CAPTAIN);
      }
      if (jp.registrar) {
        _tempAccess.add(UserProfiles.REGISTRAR);
      }
      if (jp.musicDj) {
        _tempAccess.add(UserProfiles.MUSIC_DJ);
      }
      if (jp.photosVideo) {
        _tempAccess.add(UserProfiles.PHOTOS_VIDEOS);
      }
      if (jp.hairMakeup) {
        _tempAccess.add(UserProfiles.HAIR_MAKEUP);
      }

      switch (jp.description.toString().toLowerCase()) {
        case "access to critique module":
          rolePermissions.putIfAbsent(
              AccessPermissions.CRITIQUE_MODULE, () => _tempAccess);
          break;
        case "access to heatlist module":
          rolePermissions.putIfAbsent(
              AccessPermissions.HEAT_LIST, () => _tempAccess);
          break;
        case "view all heats and participants":
          rolePermissions.putIfAbsent(
              AccessPermissions.VIEW_ALL_HEATS_PARTICIPANTS, () => _tempAccess);
          break;
        case "scratch competitors":
          rolePermissions.putIfAbsent(
              AccessPermissions.SCRATCH_COMPETITORS, () => _tempAccess);
          break;
        case "unscratch competitors":
          rolePermissions.putIfAbsent(
              AccessPermissions.UN_SCRATCH_COMPETITORS, () => _tempAccess);
          break;
        case "manage couple":
          rolePermissions.putIfAbsent(
              AccessPermissions.MANAGE_COUPLE, () => _tempAccess);
          break;
        case "add schedule judging panel":
          rolePermissions.putIfAbsent(
              AccessPermissions.SCHEDULE_JUDGING_PANEL, () => _tempAccess);
          break;
        case "mark couple check":
          rolePermissions.putIfAbsent(
              AccessPermissions.MARK_COUPLE, () => _tempAccess);
          break;
        case "statistics event monitoring test":
          rolePermissions.putIfAbsent(
              AccessPermissions.EVENT_MONITORING_STATISTICS, () => _tempAccess);
          break;
        default:
      }
    }
    Global4Config global4config = new Global4Config(
        permissions: jobPanelList, rolePermissions: rolePermissions);
  }

  static Future _saveCouple(e, Batch? b) async {
    //Database db = await DatabaseHelper.instance.database;
    try {
      String queryStr =
          "INSERT OR IGNORE INTO pi_couple(coupleKey, coupleId, uploadId, category, booked, scratched, danced, future, total) VALUES('${e["coupleKey"]}', ${e["coupleId"]}, ${e["uploadId"]}, '${e["category"]}', ${e["heatSummary"]["booked"]}, ${e["heatSummary"]["scratched"]}, ${e["heatSummary"]["danced"]}, ${e["heatSummary"]["future"]}, ${e["heatSummary"]["total"]})";
      b?.rawInsert(queryStr);

      /*int id = await db.insert("pi_couple", {
        "coupleId": e["coupleId"],
        "coupleKey": e["coupleKey"],
        "uploadId": e["uploadId"],
      });*/
    } catch (e) {
      print("INSERT ERROR: $e");
      // print(
      //     "{coupleId: ${e["coupleId"]}, coupleKey: ${e["coupleKey"]}, uploadId: ${e["uploadId"]}");
    }
  }

  static saveSoloPersons(List<dynamic> persons) async {
    Database db = await DatabaseHelper.instance.database;
    Batch b = db.batch();
    for (var i = 0; i < persons.length; i++) {
      await _savePerson(persons[i], "", b);
    }
    await b.commit(noResult: true);
  }

  static Future _savePerson(p, coupleKey, Batch? b) async {
    //Database db = await DatabaseHelper.instance.database;
    try {
      b?.rawInsert(
          "INSERT OR REPLACE INTO pi_person(personKey, firstName, lastName, gender, personType, studioId, studioKey, nickName, competitorNumber, studioName, studioIndependentInvoice, uploadId, coupleKey) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            p["personKey"],
            p["firstName"],
            p["lastName"],
            p["gender"],
            p["personType"],
            p["studioId"],
            p["studioKey"],
            p["nickName"],
            p["competitorNumber"],
            p["studioName"],
            p["studioIndependentInvoice"],
            p["uploadId"],
            coupleKey
          ]);
      //print("PI_PERSON ID[$id] ${p["firstName"]} ${p["lastName"]}");
      /*if(coupleId == 27) {
        print("PI_PERSON ID[$id] ${p["firstName"]} ${p["lastName"]}");
      }*/
    } catch (e) {
      print("INSERT ERROR: $e");
      print(
          "{personId: ${p["personId"]}, firstName: ${p["firstName"]}, lastName: ${p["lastName"]}");
    }
  }

  static saveAllJobPanels(resp, Function f) async {
    double loadDivision = 0.1 / resp.length;
    //using endpoint for heats
    List<dynamic>? endpointHeats =
        await LoadContent.httpRequest("/uberPlatform/cache/heats");
    //temporary save one panel to handle all heats
    List<dynamic> tempPanel = [];
    tempPanel.add(resp.first);
    await _saveAllPanelInfo(tempPanel);

    //Getting heats from endpoint that has same panelId to cache panels
    //List<dynamic> heats = [];
    if (endpointHeats != null) {
      //temporary disable
      // if (resp != null) {
      //   List<int> panelIds = [];
      //   //get all the panelIds
      //   for (var i = 0; i < resp.length; i++) {
      //     panelIds.add(resp[i]["panelId"]);
      //   }
      //   //process heats
      //   for (var i = 0; i < panelIds.length; i++) {
      //     heats.addAll(endpointHeats.where((e) => e["panelId"] == panelIds[i]));
      //   }
      // }
      await saveAllHeats(endpointHeats);
    }
    //************************************************************/

    Function.apply(f, [loadDivision]);

    if (resp.length <= 0) Function.apply(f, [0.6]);
  }

//static saveAllHeats(resp)
  static saveAllHeats(List<dynamic> heats) async {
    Database db = await DatabaseHelper.instance.database;
    Batch b = db.batch();
    // int heatCnt = 0;
    // print("saving heats");
    // for (var h in resp["heats"]) {
    //   int subCnt = 0;
    //   int entryCnt = 0;
    //   await _saveHeat(h, b);
    //   heatCnt += 1;
    //   // save sub heats
    //   for (var s in h["subheats"]) {
    //     await _saveSubHeat(s, b);
    //     subCnt += 1;
    //     // save entries
    //     for (var e in s["entries"]) {
    //       await _saveEntry(e, s["subHeatId"], s["heatId"], b);
    //       entryCnt += 1;
    //     }
    //   }
    //print("SUB HEATS: [$subCnt]");
    //print("ENTRIES: [$entryCnt]");
    //}

    for (var hIndex = 0; hIndex < heats.length; hIndex++) {
      await _saveHeat(heats[hIndex], b);
      //process sub heats
      List<dynamic>? subheats = heats[hIndex]["subheats"];
      if (subheats != null) {
        for (var sIndex = 0; sIndex < subheats.length; sIndex++) {
          //print("saving subheats");
          await _saveSubHeat(subheats[sIndex], b);
          //process entries
          List<dynamic>? entries = subheats[sIndex]["entries"];
          if (entries != null) {
            for (var eIndex = 0; eIndex < entries.length; eIndex++) {
              //print("saving entries");
              await _saveEntry(entries[eIndex], subheats[sIndex]["subHeatId"],
                  subheats[sIndex]["heatId"], b);
            }
          }
        }
      }
    }

    await b.commit(noResult: true);
  }

  static saveAllCouples(resp) async {
    Database? db = await DatabaseHelper.instance.database;
    Batch? b = db.batch();
    int coupleCnt = 0;
    for (var c in resp) {
      //if(c != null && c["coupleId"] != null) {
      var couple_key = await _saveCouple(c, b);
      if (couple_key != null) coupleCnt++;
      // save persons
      for (var p in c["persons"]) {
        await _savePerson(p, c["coupleKey"], b);
      }
    }
    await b.commit(noResult: true);
    print("COUPLES[$coupleCnt]");
  }

  /*static saveAllPeople(resp) async {
    int peopleCnt = 0;
    for (var p in resp) {
      int peopleId = await PiContentDao.savePeople(p);
      //if(peopleId != null)
      peopleCnt++;

      for (var a in p["assignments"]) {
        int? assignmentId = await PiContentDao.saveAssignment(a, peopleId);
      }
    }
    print("PEOPLE[$peopleCnt]");
  }*/

  static Future loadGlobalFiveConfig(e) async {
    print('Process Content Global5 Desc : ${e['heatDescription']}');
    print('Process Content Global5 Sel : ${e['heatSelection']}');
    print('Process Content Global5 danceLength : ${e['danceLength']}');
    Global5 globalFive = new Global5.fromMap(e);

    Global5Config conf = new Global5Config(settings: globalFive);
  }

  static Future loadGlobalSixConfig(e) async {
    print(
        'Process Content Global6 Critque Form Type : ${e['critiqueFormtype']}');
    // Global6 globalSix = new Global6(critiqueFormtype: e['critiqueFormtype']);

    // Global6Config conf = new Global6Config(settings: globalSix);
    if (e != null) {
      Global6Config(settings: Global6.fromMap(e));
    }
  }

  static Future loadGlobalSevenConfig(e) async {
    if (e != null) {
      Global7Config(settings: Global7.fromMap(e));
    }
  }

  static _saveToDb(List<dynamic> itemsToSave, Function saveFn) async {
    Database db = await DatabaseHelper.instance.database;
    for (var i = 0; i < itemsToSave.length; i++) {
      await Function.apply(saveFn, [itemsToSave[i], db]);
    }
    //await DatabaseHelper.instance.closeDb();
  }

  static _saveBatchDb(List<dynamic> itemsToSave, Function saveFn) async {
    Database db = await DatabaseHelper.instance.database;
    Batch b = db.batch();
    for (var i = 0; i < itemsToSave.length; i++) {
      await Function.apply(saveFn, [itemsToSave[i], b]);
    }
    List<dynamic> results = await b.commit();
    print("[${results.length}] WERE SUCCESSFULLY INSERTED.");
  }

  static Future<int> processSavingResponseData2(
      List<dynamic>? resData, Function saveFn, String processName) async {
    Stopwatch _timer = Stopwatch();
    int dataLength = 0;
    if (resData != null) {
      if (resData.isNotEmpty) {
        _timer.reset();
        _timer.start();
        await _saveBatchDb(resData, saveFn);
        _timer.stop();
        print(
            "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ processSavingResponseData[saveToDb] [$processName]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
      }
      dataLength = resData.length;
    }
    return dataLength;
  }

  static Future<int> processSavingResponseData(
      List<dynamic>? resData, Function saveFn, String processName) async {
    Stopwatch _timer = Stopwatch();
    int dataLength = 0;
    if (resData != null) {
      if (resData.isNotEmpty) {
        _timer.reset();
        _timer.start();
        await _saveToDb(resData, saveFn);
        _timer.stop();
        print(
            "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ processSavingResponseData[saveToDb] [$processName]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
      }
      dataLength = resData.length;
    }
    return dataLength;
  }

  static Future<int> _processSavingEndpointData(
      String endpoint, Function saveFn, String processName) async {
    int dataLength = 0;
    Stopwatch _timer = Stopwatch();
    _timer.reset();
    _timer.start();
    List<dynamic>? resData = await LoadContent.httpRequest(endpoint);
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ _processSavingEndpointData[httpRequest] [$processName]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");

    if (resData != null) {
      /*LogUtil.logMessageInfo("Saving $processName ${resData.length}",
          "ProcessContent-processSaving");*/
      if (resData.isNotEmpty) {
        _timer.reset();
        _timer.start();
        await _saveToDb(resData, saveFn);
        _timer.stop();
        print(
            "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ _processSavingEndpointData[saveToDb] [$processName]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
      }
      print("Done Saving $processName:${resData.length}");
      dataLength = resData.length;
    }
    return dataLength;
  }

  static int getSeconds(milli) {
    Duration dur = Duration(milliseconds: milli);
    return dur.inSeconds;
  }

  static processCompetitionData(Function f) async {
    Stopwatch _timer = Stopwatch();
    String url = "/${AppConst.urlMain}/${AppConst.urlSub}";
    double loadDivision = 0.1;

    _timer.reset();
    _timer.start();
    await _processSavingEndpointData(
        "$url/heats", PiContentDao.saveHeat, "Heat");
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ProcessContent.processCompetitionData[heats]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _timer.reset();
    _timer.start();
    await _processSavingEndpointData(
        "$url/subheats", PiContentDao.saveSubHeat, "SubHeats");
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ProcessContent.processCompetitionData[subheats]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _timer.reset();
    _timer.start();
    await _processSavingEndpointData(
        "$url/entries", PiContentDao.saveEntry, "Entries");
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ProcessContent.processCompetitionData[entries]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    _timer.reset();
    _timer.start();
    await _processSavingEndpointData(
        "$url/couples", PiContentDao.saveCouple, "Couples");
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ProcessContent.processCompetitionData[couples]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    //PERSONS: Competitor
    //PEOPLE: User
    _timer.reset();
    _timer.start();
    await _processSavingEndpointData(
        "$url/persons", PiContentDao.savePerson, "Persons");
    _timer.stop();
    print(
        "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ProcessContent.processCompetitionData[persons]: ${getSeconds(_timer.elapsedMilliseconds)} ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓");
    Function.apply(f, [loadDivision / 500]);
  }

  static processPeopleData(List<dynamic>? peoples, Function f) async {
    double loadDivision = 0.1;
    if (peoples != null) {
      Database db = await DatabaseHelper.instance.database;
      for (var pIndex = 0; pIndex < peoples.length; pIndex++) {
        await PiContentDao.savePeople(peoples[pIndex], db);
        if (peoples[pIndex]["assignments"] != null) {
          List<dynamic> assign = peoples[pIndex]["assignments"];
          for (var aIndex = 0; aIndex < assign.length; aIndex++) {
            await PiContentDao.saveAssignment(
                assign[aIndex], peoples[pIndex]["peopleId"], db);
          }
        }
      }
      print("Done Saving Peoples:${peoples.length}");
      //db.close();
    }
    Function.apply(f, [loadDivision / 500]);
  }

  static processStudio(List<dynamic>? studios, Function f) async {
    double loadDivision = 0.1;
    if (studios != null) {
      await _saveToDb(studios, PiContentDao.saveStudio);
    }
    Function.apply(f, [loadDivision / 500]);
  }
}
