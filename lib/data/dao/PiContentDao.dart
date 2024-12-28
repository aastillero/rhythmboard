import '../../utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class PiContentDao {
  static Future truncateTables() async {
    Database db = await DatabaseHelper.instance.database;
    await db.delete("pi_panel_info");
    await db.delete("pi_heat");
    await db.delete("pi_sub_heat");
    await db.delete("pi_entry");
    await db.delete("pi_couple");
    await db.delete("pi_person");
    await db.delete("pi_people");
    await db.delete("pi_assignment");
  }

  static Future saveAllPanelInfo(panelInfo) async {
    Database db = await DatabaseHelper.instance.database;
    for (var p in panelInfo) {
      int? id = await db.insert("pi_panel_info", p);
    }
  }

  static Future getAllPanelInfo() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_panel_info");
    print("PANEL INFO SAVED: [${result.length}]");
    return result;
  }

  static Future saveHeat(h, Database db) async {
    await db.insert("pi_heat", {
      "heatId": h["heatId"],
      "heatName": h["heatName"],
      "sessionKey": h["sessionKey"],
      "heatTime": h["heatTime"],
      "heatDate": h["heatDate"],
      "heatDesc": h["heatDesc"],
      "heatDance": h["heatDance"],
      "heatStatus": h["heatStatus"],
      "panelId": h["panelId"],
    });
  }

  static batchHeat(h, Batch b) {
    b.insert("pi_heat", {
      "heatId": h["heatId"],
      "heatName": h["heatName"],
      "sessionKey": h["sessionKey"],
      "heatTime": h["heatTime"],
      "heatDate": h["heatDate"],
      "heatDesc": h["heatDesc"],
      "heatDance": h["heatDance"],
      "heatStatus": h["heatStatus"],
      "panelId": h["panelId"],
    });
  }

  static Future saveStudio(s, Database db) async {
    await db.insert("pi_studio", {
      "studioId": s["studioId"],
      "studioKey": s["studioKey"],
      "studioName": s["studioName"],
    });
  }

  static Future saveSubHeat(sh, db) async {
    await db.insert("pi_sub_heat", {
      "subHeatId": sh["subHeatId"],
      "subHeatType": sh["subHeatType"],
      "subHeatDance": sh["subHeatDance"],
      "subHeatLevel": sh["subHeatLevel"],
      "subHeatAge": sh["subHeatAge"],
      "heatId": sh["heatId"],
      //"sequenceId": sh["sequenceId"],
    });
  }

  static Future batchSubHeat(sh, Batch b) async {
    b.insert("pi_sub_heat", {
      "subHeatId": sh["subHeatId"],
      "subHeatType": sh["subHeatType"],
      "subHeatDance": sh["subHeatDance"],
      "subHeatLevel": sh["subHeatLevel"],
      "subHeatAge": sh["subHeatAge"],
      "heatId": sh["heatId"],
      //"sequenceId": sh["sequenceId"],
    });
  }

  static Future saveEntry(e, db) async {
    await db.insert("pi_entry", {
      "entryId": e["entryId"],
      "entryKey": e["entryKey"],
      "entryType": e["entryType"],
      "heatId": e["heatId"],
      "subHeatId": e["subHeatId"],
      "entryStatus": e["status"],
      "peopleId": e["peopleId"],
      //"judgeNum": e["judgeNum"],
      //"subSeqId": e["subSeqId"],
      //"studioName": e["studioName"],
      //"studioKey": e["studioKey"],
    });
  }

  static Future batchEntry(e, Batch b) async {
    b.insert("pi_entry", {
      "entryId": e["entryId"],
      "entryKey": e["entryKey"],
      "entryType": e["entryType"],
      "heatId": e["heatId"],
      "subHeatId": e["subHeatId"],
      "entryStatus": e["status"],
      "peopleId": e["peopleId"],
      //"judgeNum": e["judgeNum"],
      //"subSeqId": e["subSeqId"],
      //"studioName": e["studioName"],
      //"studioKey": e["studioKey"],
    });
  }

  static Future savePeople(p, Database db) async {
    //Database? db = await DatabaseHelper.instance.database;
    int? id = await db.insert("pi_people", {
      "peopleId": p["peopleId"],
      "peopleKey": p["peopleKey"],
      "peopleName": p["peopleName"],
      "judgeNumber": p["judgeNumber"],
      "uploadId": p["uploadId"]
    });
    //print("ENTRY SAVED ID[$id], SUB HEAT ID: [$subHeatId]");
    return id;
  }

  static Future saveAssignment(a, peopleId, Database db) async {
    //Database? db = await DatabaseHelper.instance.database;
    int? id = await db.insert("pi_assignment", {
      "peopleId": peopleId,
      "panelId": a["panelId"],
      "role": a["role"],
      "time": a["time"],
      "panelDate": a["panelDate"],
      "session": a["session"]
    });
    //print("ENTRY SAVED ID[$id], SUB HEAT ID: [$subHeatId]");
  }

  static Future saveCouple(c, db) async {
    int isScratched = 0;
    int booked = 0;
    int danced = 0;
    int future = 0;
    int total = 0;
    var heatSummary = c["heatSummary"];
    if (heatSummary != null) {
      isScratched = heatSummary["scratched"];
      booked = heatSummary["booked"];
      danced = heatSummary["danced"];
      future = heatSummary["future"];
      total = heatSummary["total"];
    }
    await db.insert("pi_couple", {
      "coupleId": c["coupleId"],
      "entryKey": c["coupleKey"],
      "personId1": c["personId1"],
      "personId2": c["personId2"],
      "coupleCategory": c["category"],
      "uploadId": c["uploadId"],
      "isScratched": isScratched,
      "booked": booked,
      "danced": danced,
      "future": future,
      "total": total,
    });
  }

  static Future batchCouple(c, Batch b) async {
    int isScratched = 0;
    int booked = 0;
    int danced = 0;
    int future = 0;
    int total = 0;
    var heatSummary = c["heatSummary"];
    if (heatSummary != null) {
      isScratched = heatSummary["scratched"];
      booked = heatSummary["booked"];
      danced = heatSummary["danced"];
      future = heatSummary["future"];
      total = heatSummary["total"];
    }
    b.insert("pi_couple", {
      "coupleId": c["coupleId"],
      "entryKey": c["coupleKey"],
      "personId1": c["personId1"],
      "personId2": c["personId2"],
      "coupleCategory": c["category"],
      "uploadId": c["uploadId"],
      "isScratched": isScratched,
      "booked": booked,
      "danced": danced,
      "future": future,
      "total": total,
    });
  }

  static Future savePerson(p, db) async {
    await db.insert("pi_person", {
      "personId": p["personId"],
      "personKey": p["personKey"],
      "lastName": p["lastName"],
      "firstName": p["firstName"],
      "gender": p["gender"],
      "personType": p["personType"],
      "studioId": p["studioId"],
      "studioKey": p["studioKey"],
      "nickName": p["nickName"],
      "memberNumber": p["memberNumber"],
      "competitorNumber": p["competitorNumber"],
      "uploadId": p["uploadId"],
    });
  }

  static Future batchPerson(p, Batch b) async {
    b.insert("pi_person", {
      "personId": p["personId"],
      "personKey": p["personKey"],
      "lastName": p["lastName"],
      "firstName": p["firstName"],
      "gender": p["gender"],
      "personType": p["personType"],
      "studioId": p["studioId"],
      "studioKey": p["studioKey"],
      "nickName": p["nickName"],
      "memberNumber": p["memberNumber"],
      "competitorNumber": p["competitorNumber"],
      "uploadId": p["uploadId"],
    });
  }

  static Future getAllCouples() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_couple");
    print("SAVED COUPLES: [${result.length}]");
    return result;
  }

  static Future getAllPersons() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_person");
    print("SAVED PERSONS: [${result.length}]");
    return result;
  }

  static Future getAllPeople() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_people");
    print("SAVED PEOPLE: [${result.length}]");
    return result;
  }

  static Future getAllAssignments() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_assignment");
    print("SAVED ASSIGNMENTS: [${result.length}]");
    return result;
  }

  static Future getAllHeats() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result = await db.query("pi_heat");
    print("HEATS SAVED IN PI_HEAT: [${result.length}]");
    return result;
  }

  static Future getAllHeatsByPanelId(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_heat", where: 'panelId = ?', whereArgs: [id]);
    print("Panel ID[$id] HEATS IN PI_HEAT: [${result.length}]");
    return result;
  }

  static Future getAllSubHeatsByHeatId(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_sub_heat", where: 'heatId = ?', whereArgs: [id]);
    print("Heat ID[$id] SUBHEATS IN PI_SUB_HEAT: [${result.length}]");
    return result;
  }

  static Future getAllEntriesBySubHeatId(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_entry", where: 'subHeatId = ?', whereArgs: [id]);
    print("SubHeat ID[$id] ENTRIES IN PI_ENTRY: [${result.length}]");
    return result;
  }

  static Future getCoupleByEntryKey(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_couple", where: "coupleKey = ?", whereArgs: [id]);
    print("Couple ID[$id] Couples IN PI_COUPLE: [${result.length}]");
    return result.first;
  }

  static Future getPersonsByCoupleKey(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_person", where: 'coupleKey = ?', whereArgs: [id]);
    print("Couple ID[$id] Persons IN PI_PERSON: [${result.length}]");
    return result;
  }

  static Future getEntryByEntryId(id) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map>? result =
        await db.query("pi_entry", where: 'entryId = ?', whereArgs: [id]);
    print("SubHeat ID[$id] ENTRIES IN PI_ENTRY: [${result.length}]");
    return result;
  }

  static Future updateEntryStatusByEntryId(id, status) async {
    Database? db = await DatabaseHelper.instance.database;
    int count = await db.rawUpdate(
        'UPDATE pi_entry SET status = ? WHERE entryId = ?', [status, id]);
    print("UPDATE ENTRY COUNT: $count");
  }
}
