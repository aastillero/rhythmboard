import '../../utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/HeatData.dart';
import '../../data/models/JobPanelData.dart';
import '../../data/models/HeatCouple.dart';

class LocalContentDao {
  static Future truncateDB() async {
    Database db = await DatabaseHelper.instance.database;
    await db.delete(JobPanelData.tableName);
    await db.delete(HeatData.tableName);
    await db.delete(SubHeatData.tableName);
    await db.delete(HeatCouple.tableName);
    //await db.delete(CouplePerson.tableName);
  }

  static Future saveHeat(HeatData heat) async {
    Database db = await DatabaseHelper.instance.database;
    //int? id = await db.insert(HeatData.tableName, heat.saveMap());
    //print("HEAT DATA SAVED ID[$id]: ${heat.saveMap()}");
  }

  static Future saveJobPanelData(JobPanelData j) async {
    Database? db = await DatabaseHelper.instance.database;
    int? id = await db.insert(JobPanelData.tableName, j.saveMap());
    print("JOB PANEL DATA SAVED ID[$id]: ${j.saveMap()}");
  }

  static Future updateJobPanelData(JobPanelData j) async {
    Database? db = await DatabaseHelper.instance.database;
    int? id = await db.update(JobPanelData.tableName, j.saveMap(),
        where: 'id = ?', whereArgs: [j.id]);
    print("JOB PANEL DATA UPDATED ID[$id]");
  }

  static Future saveSubHeat(SubHeatData subheat) async {
    Database? db = await DatabaseHelper.instance.database;
    //int? id = await db.insert(SubHeatData.tableName, subheat.saveMap());
    //print("SUB HEAT DATA SAVED ID[$id]: ${subheat.saveMap()}");
  }

  /*static Future saveCouplePerson(CouplePerson p) async {
    Database? db = await DatabaseHelper.instance.database;
    int? id = await db.rawInsert(
        "INSERT OR IGNORE INTO couple_person(id, first_name, last_name, gender, age, level) VALUES(?, ?, ?, ?, ?, ?)",
        p.saveMap());
    //int id = await db.insert(CouplePerson.tableName, p.saveMap());
    print("COUPLE PERSON DATA SAVED ID[$id]");
  }*/

  static Future saveHeatCouple(HeatCouple h) async {
    Database? db = await DatabaseHelper.instance.database;
    // int? id = await db.rawInsert(
    //     "INSERT OR IGNORE INTO heat_couple(id, sub_heat_id, participant1, participant2, couple_tag, couple_level, age_category, studio, is_scratched) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",
    //     h.saveList());
    //int id = await db.insert(CouplePerson.tableName, p.saveMap());
    //print("HEAT COUPLE SAVED ID[$id]: ${h.toMap()}");
  }

  static Future selectHeatCouple(id) async {
    Database? db = await DatabaseHelper.instance.database;
    var itm = await db
        .query("heat_couple", where: 'sub_heat_id = ?', whereArgs: [id]);
    //int id = await db.insert(CouplePerson.tableName, p.saveMap());
    print("HEAT COUPLE [$id]: ${itm}");
  }
}
