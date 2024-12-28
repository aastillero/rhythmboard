import 'package:intl/intl.dart';
import 'HeatData.dart';
import 'PersonData.dart';

class JobPanelData {
  final formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");
  final formatter2 = new DateFormat("yyyy-MM-dd HH:mm");

  String? id;
  int? panel_order;
  int? heat_start;
  int? heat_end;
  DateTime? time_start;
  DateTime? time_end;
  List<HeatData>? heats;
  List<PersonData>? panel_persons;

  static final String tableName = "job_panel_data";

  JobPanelData({
    this.panel_order,
    this.heat_start,
    this.heat_end,
    this.time_start,
    this.time_end,
    this.heats,
    this.panel_persons,
  });

  JobPanelData.fromMap(Map<String, dynamic> map) {
    id = map["id"].toString();
    panel_order = map["panel_order"];
    heat_start = map["heat_start"];
    heat_end = map["heat_end"];
    if (map["time_start"] != null) {
      time_start = formatter.parse(map["time_start"]);
    }
    if (map["time_end"] != null) {
      time_end = formatter.parse(map["time_end"]);
    }
    /*if(map["heats"] != null) {
      var _temp = map["heats"];
      heats = [];
      _temp.forEach((itm){
        heats.add(new HeatData.fromMap(itm));
      });
    }
    if(map["persons"] != null) {
      var _temp = map["panel_persons"];
      panel_persons = [];
      _temp.forEach((itm){
        panel_persons.add(new Person.fromMap(itm));
      });
    }*/
  }

  JobPanelData.fromPi(Map<String, dynamic> map) {
    id = map["jobPanelId"].toString();
    panel_order = map["panel_order"];
    //heat_start = map["heat_start"];
    //heat_end = map["heat_end"];
    if (map["jobPanelTime"] != null && map["jobPanelDate"] != null) {
      time_start =
          formatter2.parse("${map["jobPanelDate"]} ${map["jobPanelTime"]}");
    }
    if (map["jobPanelTime"] != null && map["jobPanelDate"] != null) {
      time_end =
          formatter2.parse("${map["jobPanelDate"]} ${map["jobPanelTime"]}");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "panel_order": panel_order,
      "heat_start": heat_start,
      "heat_end": heat_end,
      "time_start": time_start != null
          ? formatter.format(time_start!)
          : formatter.format(new DateTime.now()),
      "time_end": time_end != null
          ? formatter.format(time_end!)
          : formatter.format(new DateTime.now()),
      //"heats": heats?.map((val) => val.toMap()),
      "panel_persons": panel_persons?.map((val) => val.toMap()),
    };
  }

  Map<String, dynamic> saveMap() {
    return {
      "id": id,
      "panel_order": panel_order,
      "heat_start": heat_start,
      "heat_end": heat_end,
      "time_start": time_start != null
          ? formatter.format(time_start!)
          : formatter.format(new DateTime.now()),
      "time_end": time_end != null
          ? formatter.format(time_end!)
          : formatter.format(new DateTime.now()),
    };
  }
}
