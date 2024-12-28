// import 'package:danceframe_et/util/DatabaseHelper.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:danceframe_et/model/Heat.dart';
import '../models/HeatDataInfo.dart';
import '../../utils/LoadContent.dart';

class HeatDao {
  static Future<HeatDataInfo?> getHeatData(String heatId) async {
    if (heatId == null || heatId.isEmpty) {
      return null;
    }

    var endpointHeat =
        await LoadContent.httpRequest("/uberPlatform/cache/heat/id/$heatId");
    print("enpoints: $endpointHeat");
  }

//   static Future getAllHeat() async {
//     Database db = await DatabaseHelper.instance.database;
//     List<HeatInfo> heats = [];
//     List<Map> result = await db.query("heat_info");
//     for(Map row in result) {
//       print(row);
//       heats.add(new HeatInfo.fromMap(row));
//     }
//     return heats;
//   }

//   static Future getHeatInfoById(String id) async {
//     Database db = await DatabaseHelper.instance.database;
//     List<Map> maps = await db.query("heat_local",
//         where: 'id = ?',
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return HeatInfo.fromMap(maps.first);
//     }
//     return null;
//   }

//   static Future getHeatsByJudge(String id) async {
//     Database db = await DatabaseHelper.instance.database;
//     List<HeatInfo> heats = [];
//     List<Map> result = await db.query("heat_local",
//         where: 'judge_id = ?',
//         whereArgs: [id],
//         orderBy: 'heat_order');
//     if (result.length > 0) {
//       for(Map row in result) {
//         print(row);
//         heats.add(new HeatInfo.fromMap(row));
//       }
//       return heats;
//     }
//     return null;
//   }

//   static Future getHeatsByJudge_pi(String id) async {
//     Database db = await DatabaseHelper.instance.database;
//     Set<HeatInfo> _heats = new Set();
//     List<Map> entries = await db.query("pi_entry",
//         where: 'peopleId = ?',
//         whereArgs: [id]);
//     if(entries != null && entries.length > 0) {
//       // get pi_heat
//       for(var e in entries) {
//         HeatInfo info = new HeatInfo();
//         List<Map> heats = await db.query("pi_heat",
//             where: 'heatId = ?',
//             whereArgs: [e["heatId"]]);
//         List<Map> subheats = await db.query("pi_sub_heat",
//             where: 'subHeatId = ?',
//             whereArgs: [e["subHeatId"]]);
//         if(heats != null && heats.length > 0) {
//           var h = heats.first;
//           info.id = h["heatId"].toString();
//           info.heat_number = h["heatName"];
//           if(subheats != null && subheats.length > 0) {
//             var sh = subheats.first;
//             info.heat_title = sh["subHeatDance"];
//           }
//           //info.assignedCouple
//           info.judge = id;
//           info.critiqueSheetType = 2;
//           _heats.add(info);
//         } else {
//           print("No heat with ID[${e["heatId"]}]");
//         }
//       }
//       return _heats;
//     } else {
//       return null;
//     }
//   }

//   static Future saveHeat(HeatInfo heat) async {
//     Database db = await DatabaseHelper.instance.database;
//     int id = await db.insert("heat_local", heat.toMap());
//     return id;
//   }

//   static Future saveAllHeats(List<HeatInfo> heats) async {
//     Database db = await DatabaseHelper.instance.database;
//     for(HeatInfo heat in heats) {
//       int id = await db.insert("heat_local", heat.toMap());
//     }
//   }

//   static Future removeHeatLocal() async {
//     Database db = await DatabaseHelper.instance.database;
//     db.rawDelete("DELETE FROM heat_local");
//   }
}
