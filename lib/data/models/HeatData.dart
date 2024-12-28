import 'HeatCouple.dart';
import 'package:intl/intl.dart';

final formatter = new DateFormat("HH:mm");

class SubHeatData {
  late int id;
  //int? seqId;
  late int heatId;
  late String subHeatDance;
  late String subHeatLevel;
  late String subHeatAge;
  late String subHeatType;
  late String finalState = "F";
  List<HeatCouple> couples = [];

  static final String tableName = "sub_heat_data";

  SubHeatData(this.id, this.subHeatDance, this.subHeatLevel, this.subHeatType,
      this.finalState, this.couples);

  SubHeatData.fromMap(Map<String, dynamic> map) {
    id = map["subHeatId"];
    //seqId = map["sequenceId"];
    subHeatDance = map["subHeatDance"] ?? "";
    subHeatLevel = map["subHeatLevel"] ?? "";
    subHeatAge = map["subHeatAge"];
    subHeatType = map["subHeatType"];
    //finalState = map["heat_data_id"];
  }

  SubHeatData.fromPi(Map<String, dynamic> map) {
    // id = map["subHeatId"].toString();
    // seqId = map["sequenceId"];
    // sub_title = map["subHeatLevel"] ?? map["subHeatlevel"];
    // heat_data_id = map["heatId"].toString();
    // sub_heat_age = map["subHeatAge"];
    // subHeatType = map["subHeatType"];
    // subHeatDance = map["subHeatDance"] ?? map["subHeatdance"];
    // finalState = map["finalState"];
    // //print("subheatage: ${map["subHeatAge"]}");
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      //"sequenceId": seqId,
      //"sub_title": sub_title,
      "subHeatdance": subHeatDance,
      "subHeatLevel": subHeatLevel,
      "subHeatAge": subHeatAge,
      "subHeatType": subHeatType
    };
  }

// Map<String, dynamic> saveMap() {
//   return {
//     "id": id,
//     "sub_title": sub_title,
//     "subHeatdance": subHeatDance,
//     "heat_data_id": heat_data_id
//   };
// }
}

class HeatData {
  late int id;
  //String? panel_data_id;
  late String heatName;
  late String heatDesc;
  late String heatDance;
  late DateTime heatTime;
  List<SubHeatData> subHeats = [];
  //int? critique_sheet_type; // type 1 = scoresheet // type 2 = components
  //int? heat_order;
  ///2 - started
  ///3- done
  late int heatStatus;

  static final String tableName = "heat_data";

  HeatData(this.heatName, this.heatDesc, this.heatDance, this.subHeats,
      this.heatTime, this.heatStatus);

  HeatData.fromMap(Map<String, dynamic> map) {
    id = map["heatId"];
    heatName = map["heatName"];
    heatDesc = map["heatDesc"];
    heatDance = map["heatDance"];
    heatStatus = map["heatStatus"];
    heatTime = formatter.parse(map["heatTime"]);
    // panel_data_id = map["panel_data_id"].toString();
    // if (map["time_start"] != null) {
    //   time_start = formatter.parse(map["time_start"]);
    // }
    /*if(map["sub_heat"] != null) {
      sub_heat = new SubHeatData.fromMap(map["sub_heat"]);
    }*/
    // critique_sheet_type = map["critique_sheet_type"];
    // heat_order = map["heat_order"];
  }

// HeatData.fromPi(Map<String, dynamic> map) {
//   id = map["heatId"];
//   heatName = map["heatName"];
//   heat_title = map["heatDesc"];
//   heat_title_short = map["heatDance"];
//   panel_data_id = map["panelId"].toString();
//   if (map["heatTime"] != null) {
//     time_start = formatter.parse(map["heatTime"]);
//   }
//   /*if(map["sub_heat"] != null) {
//     sub_heat = new SubHeatData.fromMap(map["sub_heat"]);
//   }*/
//   critique_sheet_type = 2;
//   //heat_order = map["heat_order"];
// }

// Map<String, dynamic> toMap() {
//   return {
//     "id": id,
//     "heatName": heatName,
//     "heat_title": heat_title,
//     "time_start": time_start != null
//         ? formatter.format(time_start!)
//         : formatter.format(new DateTime.now()),
//     "sub_heats": sub_heats?.map((val) => val.toMap()),
//     "critique_sheet_type": critique_sheet_type,
//     "heat_order": heat_order,
//   };
// }

// Map<String, dynamic> saveMap() {
//   return {
//     "id": id,
//     "heatName": heatName,
//     "job_panel_data_id": panel_data_id,
//     "heat_title": heat_title,
//     "time_start": time_start != null
//         ? formatter.format(time_start!)
//         : formatter.format(new DateTime.now()),
//     "critique_sheet_type": critique_sheet_type,
//     "heat_order": heat_order,
//   };
// }
}

class Entry {
  late int id;
  late String entryKey;
  late int entryType;
  late String primaryEntry;
  late int heatId;
  late int subHeatId;
  late int peopleId;

  Entry.fromMap(Map<String, dynamic> data) {
    id = data["entryId"];
    entryKey = data["entryKey"];
    entryType = data["entryType"];
    primaryEntry = data["primaryEntry"] ?? "";
    heatId = data["heatId"];
    subHeatId = data["subHeatId"];
    peopleId = data["peopleId"];
  }
}
