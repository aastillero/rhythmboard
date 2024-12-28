import 'package:uber_display/model/HeatData.dart';

class HeatMapper {

  static HeatData mapFromPiHeat(piHeat) {
    return HeatData.fromMap({
      "id": piHeat["heatId"],
      "panel_data_id": piHeat["panelId"],
      "heat_number": piHeat["heatName"],
      "heat_title": piHeat["heatDesc"],
      "time_start": piHeat["heatTime"]
    });
  }
}