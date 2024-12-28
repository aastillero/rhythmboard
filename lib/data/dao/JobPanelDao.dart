import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/HeatCouple.dart';
import '../models/HeatData.dart';
import '../models/JobPanelData.dart';
import '../models/PersonData.dart';
import '../../utils/DatabaseHelper.dart';

class JobPanelDao {
  static List<JobPanelData> _jobPanels = [];
  //static Database _db;
  //static Stopwatch _ =watch = new Stopwatch();

  static Future<Database> dbInstance() async {
    return await DatabaseHelper.instance.database;
  }

  static Future loadAllPanels(Function f) async {
    //_db = await DatabaseHelper.instance.database;
    if (_jobPanels.isEmpty) {
      await _getAllJobPanelData();
    }
    int cnt = 0;
    for (var j in _jobPanels) {
      //if(j.heats == null || j.heats.isEmpty) {
      j.heats = await _getAllHeatsByPanelId(j.id!);
      if (j.heats!.length > 0) {
        //j.heat_start = int.parse(j.heats![0].id!);
        //j.heat_end = int.parse(j.heats![j.heats!.length - 1].id!);
        //j.time_end = j.heats![j.heats!.length - 1].time_start;
      }
      //}
      cnt++;
//      print("cnt: $cnt  jlength: ${_jobPanels.length}");
      Function.apply(f, [j, cnt == _jobPanels.length]);
    }
  }

  static Future _getAllJobPanelData() async {
    var _db = await dbInstance();
    List<Map<String, dynamic>> result = await _db.query("pi_panel_info");
    _jobPanels = [];
    for (Map<String, dynamic> row in result) {
      JobPanelData data = new JobPanelData.fromPi(row);
      _jobPanels.add(data);
    }
  }

  static Future _getAllHeatsByPanelId(String id) async {
    var _db = await dbInstance();
    List<HeatData> heats = [];
    List<Map<String, dynamic>> maps =
        await _db.query("pi_heat", where: 'panelId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      for (var itm in maps) {
        //HeatData h = new HeatData.fromPi(itm);
        //h.sub_heats = await getSubHeatDataByHeatId(h.id!);
        //h.sub_heats = await getSubHeatDataByHeatDataId_pi(h.id);
        //h.isStarted = await _getHeatStartValue("heat_started", int.parse(h.id));
        //h.isStarted = false;
        //h.isStarted = (itm != null && itm["is_started"] == 3) ? true : false;
        //heats.add(h);
      }
      print("Done loading heats [${heats.length}]");
      return heats;
    }
    return null;
  }

  static Future _getHeatStartValue(tableName, id) async {
    var fd = await _getStartedByHeatId(tableName, id);
    bool retVal = (fd != null && fd["is_started"] == 1) ? true : false;
    return retVal;
  }

  static Future _getStartedByHeatId(tableName, id) async {
    var _db = await dbInstance();
    List<Map> maps =
        await _db.query(tableName, where: 'heat_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  static Future getPersonDataByPanelId(String id) async {
    var _db = await dbInstance();
    List<PersonData> persons = [];
    List<Map> result =
        await _db.query("pi_assignment", where: 'panelId = ?', whereArgs: [id]);
    for (Map row in result) {
      print(row);
      String fname = "";
      String lname = "";
      print("ROLE: ${row["role"]}");
      // get user roles
      String _role = row["role"];
      List<Map> res = await _db.query("pi_people",
          where: 'peopleId = ?', whereArgs: [row["peopleId"]]);
      for (var a in res) {
        if (a["peopleName"] != null) {
          List<String> _name = a["peopleName"].split(" ");
          if (_name.length > 0) {
            fname = _name[0];
            lname = _name[1];
          }
        }
        print("PEOPLE NAME: $fname $lname");
        persons.add(new PersonData.fromMap({
          "id": row["peopleId"],
          "first_name": fname,
          "last_name": lname,
          "gender": "Male",
          "user_roles": _role
        }));
      }
    }
    return persons;
  }

  static Future getSubHeatDataByHeatId(String id) async {
    var _db = await dbInstance();
    List<SubHeatData> subHeats = [];
    List<Map<String, dynamic>> maps =
        await _db.query("pi_sub_heat", where: 'heatId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      for (var itm in maps) {
        //print("PI_SUB_HEAT DATA: $itm");
        SubHeatData h = new SubHeatData.fromPi(itm);
        // h.couples = await _getSubHeatCouplesBySubHeatId(
        //     h.id!, itm["subHeatLevel"], itm["subHeatAge"]);
        //print("COUPLES: ${h.couples.length}");
        subHeats.add(h);
      }
      //subHeats.sort(((a, b) => (a.seqId ?? 0).compareTo(b.seqId ?? 0)));
      return subHeats;
    }
    return null;
  }

  static Future updateHeatStartedById(String heatId, int status) async {
    var _db = await dbInstance();
    _db = await DatabaseHelper.instance.database;
    _db.rawUpdate(
        'UPDATE pi_heat SET is_started = ? WHERE heatId = ?', [status, heatId]);
  }

  static Future _getSubHeatCouplesBySubHeatId(
      String subHeatId, subHeatLevel, subHeatAge) async {
    Database db = await DatabaseHelper.instance.database;
    List<HeatCouple> couples = [];

    List<Map<String, dynamic>> entries = await db
        .query("pi_entry", where: 'subHeatId = ?', whereArgs: [subHeatId]);

    for (var i = 0; i < entries.length; i++) {
      //validate entryType first
      //if 1 = solo, 2 = couples
      if (entries[i]["entryType"] == 1) {
        List<Map<String, dynamic>> rawPersonData = await db.query("pi_person",
            where: 'personKey = ?', whereArgs: [entries[i]["entryKey"]]);

        /*CouplePerson singlePerson = CouplePerson.fromPi(rawPersonData[0]);
        //Manual Heat Couple values
        HeatCouple c = HeatCouple(
            participant1: singlePerson,
            age_category: subHeatAge,
            couple_level: subHeatLevel,
            sub_heat_id: subHeatId,
            id: singlePerson.id,
            studio: entries[i]["studioName"],
            couple_tag: entries[i]["entryKey"],
            couple_key: entries[i]["entryKey"],
        );*/

        //c.couple_key = entries[i]["entryKey"];
        //c.is_scratched = (entries[i]["status"] != 1) ? true : false;
        //c.entry_id = entries[i]["entryId"].toString();
        bool onDeck =
            await _getOnFloorDeckValue("couple_on_deck", entries[i]["entryId"]);
        bool onFloor = await _getOnFloorDeckValue(
            "couple_on_floor", entries[i]["entryId"]);
        //c.onDeck = onDeck;
        //c.onFloor = onFloor;
        //couples.add(c);
      } else {
        //get couple base on entry key
        List<Map<String, dynamic>> rawCoupleData = await db.query("pi_couple",
            where: 'coupleKey = ?', whereArgs: [entries[i]["entryKey"]]);
        //loop through couples and add to couple lists
        for (var itm in rawCoupleData) {
          /*HeatCouple c =
          new HeatCouple.fromPi(itm, subHeatId, subHeatLevel, subHeatAge);
          c.is_scratched = (entries[i]["status"] != 1) ? true : false;
          c.entry_id = entries[i]["entryId"].toString();
          c.studio = entries[i]["studioName"];*/
          // query participants via coupleKey
          //await _getSubHeatParticipantById(itm["coupleKey"], c);
          bool onDeck = await _getOnFloorDeckValue(
              "couple_on_deck", entries[i]["entryId"]);
          bool onFloor = await _getOnFloorDeckValue(
              "couple_on_floor", entries[i]["entryId"]);
          //c.onDeck = onDeck;
          //c.onFloor = onFloor;
          //couples.add(c);
        }
      }
    }
    return couples;
  }

  static Future _getOnFloorDeckValue(tableName, id) async {
    var fd = await _getOnFloorDeckByEntryId(tableName, id);
    bool retVal = (fd != null && fd["on_value"] == 1) ? true : false;
    return retVal;
  }

  static Future _getOnFloorDeckByEntryId(tableName, id) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map> maps =
        await db.query(tableName, where: 'entry_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  static Future _getSubHeatParticipantById(id, c) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query("pi_person", where: 'coupleKey = ?', whereArgs: [id]);
    //print("SELECT pi_person where coupleKey = $id LENGTH[${maps.length}]");
    if (maps.length > 0) {
      int cnt = 0;
      for (var p in maps) {
        if (cnt == 0) {
          //c.participant1 = CouplePerson.fromPi(p);
        } else {
          //c.participant2 = CouplePerson.fromPi(p);
        }
        cnt += 1;
      }
    }
    //print("participant1: ${c.participant1}");
    //print("participant2: ${c.participant2}");
  }
}
