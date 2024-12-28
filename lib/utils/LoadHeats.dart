import '../data/dao/HeatDataDao.dart';
import '../data/models/HeatCouple.dart';
import '../data/models/HeatData.dart';

class LoadHeats {
  static List<HeatData> heats = [];
  static List<int> heatToggled = [];
  static List<Map<int, int>> coupleToggled = [];

  static initializeHeats(resp) {
    if (resp["heats"] != null) {
      if (resp["heats"].isNotEmpty) {
        heats = (resp["heats"] as List<dynamic>)
            .map((e) => HeatData.fromMap(e))
            .toList();
        List<SubHeatData> subHeats = (resp["subheats"] as List<dynamic>)
            .map((e) => SubHeatData.fromMap(e))
            .toList();
        List<HeatCouple> couples = (resp["couples"] as List<dynamic>)
            .map((e) => HeatCouple.fromMap(e))
            .toList();
        for (HeatData heat in heats) {
          for (SubHeatData shd in subHeats) {
            shd.couples = _filterCouple(couples, shd.id);
          }
          heat.subHeats = _filterSH(subHeats, heat.id);
        }
      }
    }
  }

  static List<SubHeatData> _filterSH(List<SubHeatData> subHeats, int heatId) {
    List<SubHeatData> retVal = [];
    for (SubHeatData subHeat in subHeats) {
      if (subHeat.id == heatId) {
        retVal.add(subHeat);
      }
    }
    return retVal;
  }

  static List<HeatCouple> _filterCouple(
      List<HeatCouple> couples, int subHeatId) {
    List<HeatCouple> retVal = [];
    for (HeatCouple hc in couples) {
      if (hc.id == subHeatId) {
        retVal.add(hc);
      }
    }
    return retVal;
  }

  static initHeats() async {
    print("----------INIT HEATS----------");
    heats = await HeatDataDao.getAllHeats();
    //print("----------TOTAL:${heats.length}----------");

    for (var hI = 0; hI < heats.length; hI++) {
      var subHeats = await _initSubHeats(heats[hI].id);
      for (var shI = 0; shI < subHeats.length; shI++) {
        subHeats[shI].couples = await _initHeatCouple(subHeats[shI].id);
      }
      heats[hI].subHeats = subHeats;
    }
  }

  static Future<List<SubHeatData>> _initSubHeats(int heatId) async {
    //print("----------INIT SUBHEATS FOR heat[$heatId]----------");
    var subHeats = await HeatDataDao.getAllSubHeatByHeatId(heatId);
    // print(
    //     "----------TOTAL SUBHEAT FOR heat[$heatId]:${subHeats.length}----------");
    return subHeats;
  }

  static Future<List<HeatCouple>> _initHeatCouple(int subHeatId) async {
    // print("----------INIT COUPLES FOR SUBHEAT[$subHeatId]----------");
    var entries = await HeatDataDao.getEntriesBySubHeatId(subHeatId);
    List<HeatCouple> retVal = [];
    if (entries.isNotEmpty) {
      for (var i = 0; i < entries.length; i++) {
        var hc = await HeatDataDao.getCoupleByEntry(entries[i]);
        if (hc != null) retVal.add(hc);
      }
    }
    // print(
    //     "----------TOTAL COUPLES FOR SUBHEAT[$subHeatId]:${retVal.length}----------");
    return retVal;
  }
}
