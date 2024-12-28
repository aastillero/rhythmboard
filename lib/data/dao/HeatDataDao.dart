import '../../utils/DatabaseHelper.dart';
import '../../data/models/HeatCouple.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/HeatData.dart';

class HeatDataDao {
  static Future<List<HeatData>> getAllHeats() async {
    Database db = await DatabaseHelper.instance.database;
    List<HeatData> retVal = [];
    var heats = await db.query("pi_heat");
    if (heats.isNotEmpty) {
      retVal = heats.map((e) => HeatData.fromMap(e)).toList();
    }
    return retVal;
  }

  static Future<List<SubHeatData>> getAllSubHeatByHeatId(int heatId) async {
    Database db = await DatabaseHelper.instance.database;
    List<SubHeatData> retVal = [];
    var subHeats =
        await db.query("pi_sub_heat", where: "heatId = ?", whereArgs: [heatId]);
    if (subHeats.isNotEmpty) {
      retVal = subHeats.map((e) => SubHeatData.fromMap(e)).toList();
    }
    return retVal;
  }

  static Future<List<Entry>> getEntriesBySubHeatId(int subHeatId) async {
    Database db = await DatabaseHelper.instance.database;
    List<Entry> retVal = [];

    var res = await db
        .query("pi_entry", where: "subHeatId = ?", whereArgs: [subHeatId]);
    if (res.isNotEmpty) {
      retVal = res.map((e) => Entry.fromMap(e)).toList();
    }
    return retVal;
  }

  static Future<HeatCouple?> getCoupleByEntry(Entry entry) async {
    Database db = await DatabaseHelper.instance.database;
    HeatCouple? retVal;
    var res = await db
        .query("pi_couple", where: "entryKey = ?", whereArgs: [entry.entryKey]);
    if (res.isNotEmpty) {
      retVal = HeatCouple.fromMap(res.first);
      retVal.entryType = entry.entryType;

      List<Participant> participants = [];
      var p1 =
          await getParticipantByPersonId(int.parse("${res[0]["personId1"]}"));
      if (p1 != null) {
        participants.add(p1);
        retVal.studioName = await getStudioById(int.parse("${p1.studioId}"));
      }
      var p2 =
          await getParticipantByPersonId(int.parse("${res[0]["personId2"]}"));
      if (p2 != null) {
        participants.add(p2);
      }
      retVal.participants = participants;
      retVal.entryId = entry.id;

      if (res[0]["onDeck"] != null) {
        retVal.onDeck = res[0]["onDeck"] as bool;
      }
      if (res[0]["onFloor"] != null) {
        retVal.onFloor = res[0]["onFloor"] as bool;
      }
      if (res[0]["started"] != null) {
        retVal.onFloor = res[0]["started"] as bool;
      }
    }
    return retVal;
  }

  static Future<Participant?> getParticipantByPersonId(int personId) async {
    Database db = await DatabaseHelper.instance.database;
    Participant? retVal;
    var res = await db
        .query("pi_person", where: "personId = ?", whereArgs: [personId]);
    if (res.isNotEmpty) {
      retVal = Participant.fromMap(res.first);
    }
    return retVal;
  }

  static Future<String> getStudioById(int studioId) async {
    Database db = await DatabaseHelper.instance.database;
    String retVal = "";
    var res = await db
        .query("pi_studio", where: "studioId = ?", whereArgs: [studioId]);
    if (res.isNotEmpty) {
      retVal = "${res[0]["studioName"]}";
    }
    return retVal;
  }

  static Future saveHeatData(HeatData h) async {
    Database db = await DatabaseHelper.instance.database;
    //int id = await db.insert(HeatData.tableName, h.toMap());
    //return id;
  }

  static Future getHeatDataById(String id) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query(HeatData.tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return HeatData.fromMap(maps.first);
    }
    return null;
  }

  static Future getHeatDataByJudge(String id) async {
    Database db = await DatabaseHelper.instance.database;
    List<HeatData> heats = [];
    List<Map<String, dynamic>> result = await db.query(HeatData.tableName,
        where: 'judge_id = ?', whereArgs: [id], orderBy: 'heat_order');
    if (result.length > 0) {
      for (Map<String, dynamic> row in result) {
        print(row);
        heats.add(new HeatData.fromMap(row));
      }
      return heats;
    }
    return null;
  }

  static Future saveAllHeatData(List<HeatData> heats) async {
    Database db = await DatabaseHelper.instance.database;
    for (HeatData heat in heats) {
      // await db.insert(HeatData.tableName, heat.toMap());
    }
  }

// static Future<HeatCouple?> getHeatCoupleByEntryKey(
//     String entryKey, int subHeatId, int entryId, int entryType) async {
//   // load couple entry
//   var piCouple = await PiContentDao.getCoupleByEntryKey(entryKey);
//   // load persons for couple
//   var piPersons =
//       await PiContentDao.getPersonsByCoupleKey(piCouple["coupleKey"]);
//   String studio = "";
//   SubHeatData? sh = await JobPanelDao.getSubHeatDataBySubHeatId(subHeatId);
//   // HeatCouple hc = EntryMapper.mapFromPiEntry(piCouple,
//   //     subHeatId, sh?.sub_title ?? "", sh?.sub_heat_age ?? "", studio);
//   HeatCouple hc = HeatCouple.fromMap(
//       piCouple, subHeatId, sh?.sub_title ?? "", sh?.sub_heat_age ?? "");
//   for (var p in piPersons) {
//     Participant cp =
//         //EntryMapper.mapFromPiPerson(p, sh?.sub_title?? "");
//         Participant.fromPi(p);
//     if (studio != "") {
//       hc.participant2 = cp;
//     } else {
//       hc.participant1 = cp;
//     }
//     studio = p["studioName"];
//   }
//   hc.entry_id = "$entryId";
//   hc.studio = studio;
//   hc.entryType = entryType;

//   // query participants via coupleKey
//   await JobPanelDao.getSubHeatParticipantById(hc.couple_key, hc);
//   bool onDeck =
//       await JobPanelDao.getOnFloorDeckValue("couple_on_deck", entryId);
//   bool onFloor =
//       await JobPanelDao.getOnFloorDeckValue("couple_on_floor", entryId);
//   hc.onDeck = onDeck;
//   hc.onFloor = onFloor;
//   return hc;
// }
}
