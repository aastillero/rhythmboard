import 'package:uber_display/model/HeatData.dart';

class SubHeatMapper {

  static SubHeatData mapFromPiSubHeat(sub) {
    return SubHeatData.fromMap({
      "id": sub["subHeatId"],
      "sub_title": sub["subHeatLevel"]
    });
  }
}