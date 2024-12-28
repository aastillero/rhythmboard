import '../data/models/HeatCouple.dart';

import 'LoadHeats.dart';
import '../data/models/HeatData.dart';
import '../data/models/HeatDataInfo.dart';
import 'package:get/get.dart';

class HeatDataProcess {
  static bool isHeatToggled(int heatId) {
    var res = LoadHeats.heatToggled.firstWhereOrNull((e) => e == heatId);
    return res != null ? true : false;
  }

  static bool isCoupleToggled(int heatId, int subHeatId, int coupleId) {
    bool retVal = false;
    if (isHeatToggled(heatId)) {
      var res = LoadHeats.coupleToggled.firstWhereOrNull(
          (e) => e.containsKey(subHeatId) && e.containsValue(coupleId));
      if (res != null) retVal = true;
    }
    return retVal;
  }

  static heatToggle(int heatId, bool isToggled) {
    if (isToggled) {
      LoadHeats.heatToggled.add(heatId);
    } else {
      LoadHeats.heatToggled.remove(heatId);
    }
  }

  static coupleToggle(int heatId, int subHeatId, int coupleId, bool isToggled) {
    if (isToggled) {
      LoadHeats.coupleToggled.add({subHeatId: coupleId});
    } else {
      LoadHeats.coupleToggled.removeWhere(
          (e) => e.containsKey(subHeatId) && e.containsValue(coupleId));
    }
  }

  static Participant? determineLevel(
      Participant? p1, Participant? p2, String lvl) {
    if (p1?.personType == lvl) {
      return p1;
    } else {
      return p2;
    }
  }

  static Participant? determineGender(
      Participant? p1, Participant? p2, gender) {
    if (p1?.gender == gender) {
      return p1;
    } else {
      return p2;
    }
  }

  static HeatDataInfo getHeatData(int heatId) {
    HeatData? heatData = searchHeatData(heatId);
    // pull participants
    HeatDataInfo retval = HeatDataInfo(
        heatId: 0, heatName: "", heatTitle: "", heatTitleShort: "");
    Map<String, List<ParticipantInfo>> shMap = {};

    if (heatData != null) {
      for (var sh in heatData.subHeats) {
        List<ParticipantInfo> participants = [];
        print("SUBHEAT: ${sh.toMap()}");
        for (var c in sh.couples) {
          String couple_participant = "";
          Participant? p1;
          Participant? p2;
          if (c.participants.isNotEmpty && c.participants.length > 1) {
            p1 = c.participants[0];
            p2 = c.participants[1];
            if (p1.personType == p2.personType) {
              var couple = determineGender(p1, p2, "M");
              couple_participant +=
                  "${c.entryKey}|${couple?.firstName} ${couple?.lastName}";
              couple = determineGender(p1, p2, "F");
              couple_participant +=
                  " / ${couple?.firstName} ${couple?.lastName}";
            } else {
              var couple = determineLevel(p1, p2, "A");
              couple_participant +=
                  "${c.entryKey}|${couple?.firstName} ${couple?.lastName}";
              couple = determineLevel(p1, p2, "P");
              couple_participant +=
                  " / ${couple?.firstName} ${couple?.lastName}";
            }
          } else if (c.participants.isNotEmpty && c.participants.length < 2) {
            couple_participant +=
                "${c.category}|${c.participants[0].firstName} ${c.participants[0].lastName}";
          }

          if (couple_participant != null && couple_participant != "") {
            //print("PARTICIPANT ADDED...");
            ParticipantInfo pi = ParticipantInfo();
            pi.isScratched = c.isScratched;
            pi.participant = couple_participant;
            pi.subHeatName = sh.subHeatDance;
            pi.subHeatId = "${sh.id}";
            //print("id:${heatData.heatName} title: ${sh.sub_title} heatDance:${sh.subHeatDance}");
            //print("SubHeatName:[${sh.sub_title}] SubHeat ID:[${sh.id}] SubHeat seqId:[${sh.seqId}]");
            participants.add(pi);
          }
        }
        shMap.putIfAbsent("${sh.id}", () => participants);
      }

      bool isFormation = false;
      if (heatData.heatName?.toUpperCase().contains("FORMATION") ?? false) {
        isFormation = true;
      }

      retval = HeatDataInfo(
          heatId: heatId,
          heatName: heatData.heatName,
          heatTitle: heatData.heatDesc,
          participants: shMap,
          heatTitleShort: heatData.heatDance);
    }

    return retval;
  }

  static HeatData? searchHeatData(int heatId) {
    HeatData? heatData;
    if (heatId != 0) {
      try {
        heatData = LoadHeats.heats.firstWhereOrNull((h) => h.id == heatId);
      } catch (e) {
        print("LogUtil _searchHeatData: ${e.toString()}");
        //LogUtil.logErrorMsg("_searchHeatData", e.toString());
      }
    }
    return heatData;
  }

  static updateHeatStatus(int heatId, int heatStatus) {
    int heatIndex = LoadHeats.heats.indexWhere((h) => h.id == heatId);
    if (heatIndex != -1) {
      LoadHeats.heats[heatIndex].heatStatus = heatStatus;
    }
  }

  static int getNextHeat(int currentHeatId) {
    int retVal = currentHeatId;
    int initialHeatIndex =
        (LoadHeats.heats.indexWhere((h) => h.id == currentHeatId) + 1);
    for (var i = initialHeatIndex; i < LoadHeats.heats.length; i++) {
      if (LoadHeats.heats[i].heatStatus == 0 ||
          LoadHeats.heats[i].heatStatus == 1) {
        retVal = LoadHeats.heats[i].id;
        break;
      }
    }
    return retVal;
  }

  static updateScratchByEntryId(int entryId, bool value) {
    for (var h = 0; h < LoadHeats.heats.length; h++) {
      for (var sh = 0; sh < LoadHeats.heats[h].subHeats.length; sh++) {
        for (var c = 0;
            c < LoadHeats.heats[h].subHeats[sh].couples.length;
            c++) {
          if (LoadHeats.heats[h].subHeats[sh].couples[c].entryId == entryId) {
            LoadHeats.heats[h].subHeats[sh].couples[c].isScratched = value;
            break;
          }
        }
      }
    }
  }
}
