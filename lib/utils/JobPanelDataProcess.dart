import '../data/models/HeatData.dart';
import '../data/models/HeatDataInfo.dart';
import '../utils/LoadJobPanel.dart';
import '../data/models/HeatCouple.dart';
import '../utils/HttpUtil.dart';
import '../data/models/ManageEntry.dart';
import '../data/models/config/DeviceConfig.dart';

class JobPanelDataProcess {
  ///get next not-started heat
  int getNextHeatIndex(int heatId, {int? jobPanelId}) {
    int index = heatId;

    //jobpanelheatrow widget have access on jobpanel id, for easy searching of heat
    //if no jobpanel id has been passed, can do a deep search
    int jobPanelIndex;
    if (jobPanelId == null) {
      //jobPanelIndex = int.parse(_searchHeatData(heatId).panel_data_id!);
    } else {
      jobPanelIndex = jobPanelId;
    }
    // bool? isStarted = LoadJobPanel.jobPanels![jobPanelIndex - 1].heats
    //     ?.firstWhere((element) => element.id == index.toString())
    //     .isStarted;
    // while (isStarted!) {
    //   index++;
    // }
    return index;
  }

  // CouplePerson? determineLevel(CouplePerson? p1, CouplePerson? p2, ParticipantLevel lvl) {
  //   if(p1?.level == lvl) {
  //     return p1;
  //   } else {
  //     return p2;
  //   }
  // }
  //
  // CouplePerson? determineGender(CouplePerson? p1, CouplePerson? p2, gender) {
  //   if(p1?.gender == gender) {
  //     return p1;
  //   } else {
  //     return p2;
  //   }
  // }

  HeatDataInfo getHeatData(int? heatId) {
    //print("BEFORE _searchHeatData heatId[$heatId] ==================================");
    HeatData heatData = _searchHeatData(heatId!);
    Map<String, List<ParticipantInfo>> shMap = {};
    //print("BEFORE IF heatData ==================================");
    // if(heatData != null && heatData.sub_heats != null) {
    //   //print("INSIDE IF heatData ==================================");
    //   for(var sh in heatData.sub_heats!) {
    //     //print("sh: ${sh}");
    //     //List<String> participants = [];
    //     List<ParticipantInfo> participants = [];
    //     //print("SH: ${sh.toMap()}");
    //     //print("INSIDE for loop ==================================");
    //     for(var c in sh.couples!) {
    //       String couple_participant = "";
    //       //print("COUPLE: ${c.toMap()}");
    //       /*
    //         IF COUPLE is AM-AM or PRO-PRO
    //           THEN The male should be first
    //         ELSE IF COUPLE is PRO-AM
    //           THEN The AM should be first
    //        */
    //       if(c.participant2 == null) {
    //         couple_participant += "${c?.couple_tag}|${c.participant1?.first_name} ${c.participant1?.last_name!}";
    //       }
    //       else {
    //         if(c.participant1?.level == c.participant2?.level) {
    //           //print("LEVEL is EQUAL: [${c.participant1?.level}] != [${c.participant2?.level}]");
    //           /*if(c.participant1 != null) {
    //                       var couple = c?.participant1;
    //                       //print("Heat [${heatData.id}] couple [${couple?.first_name} ${couple?.last_name!}]");
    //                       couple_participant += "${c?.couple_tag}|${couple?.first_name} ${couple?.last_name!}";
    //                     }
    //                     if(c.participant2 != null) {
    //                       var couple = c.participant2;
    //                       //print("Heat [${heatData.id}] couple [${couple?.first_name!} ${couple?.last_name!}]");
    //                       couple_participant += " / ${couple?.first_name} ${couple?.last_name!}";
    //                     }*/
    //           var couple = determineGender(c.participant1, c.participant2, "M");
    //           couple_participant += "${c?.couple_tag}|${couple?.first_name} ${couple?.last_name!}";
    //           couple = determineGender(c.participant1, c.participant2, "F");
    //           couple_participant += " / ${couple?.first_name} ${couple?.last_name!}";
    //         } else {
    //           //print("LEVEL is NOT EQUAL: [${c.participant1?.level}] != [${c.participant2?.level}]");
    //           var couple = determineLevel(c.participant1, c.participant2, ParticipantLevel.AM);
    //           couple_participant += "${c?.couple_tag}|${couple?.first_name} ${couple?.last_name!}";
    //           couple = determineLevel(c.participant1, c.participant2, ParticipantLevel.PRO);
    //           couple_participant += " / ${couple?.first_name} ${couple?.last_name!}";
    //         }
    //       }
    //
    //       //print("COUPLE PARTICIPANT: ${couple_participant}");
    //       if(couple_participant != null && couple_participant != "") {
    //         //print("PARTICIPANT ADDED...");
    //         ParticipantInfo pi = ParticipantInfo();
    //         pi.isScratched = c.is_scratched;
    //         pi.participant = couple_participant;
    //         pi.subHeatName = sh.sub_title;
    //         pi.subHeatId = sh.id;
    //         //print("id:${heatData.heatName} title: ${sh.sub_title} heatDance:${sh.subHeatDance}");
    //         //print("SubHeatName:[${sh.sub_title}] SubHeat ID:[${sh.id}] SubHeat seqId:[${sh.seqId}]");
    //         participants.add(pi);
    //       }
    //     }
    //     shMap.putIfAbsent(sh.id!, () => participants);
    //   }
    // }
    //
    // bool isFormation = false;
    // if(heatData.heat_title?.toUpperCase().contains("FORMATION") ?? false) {
    //   isFormation = true;
    // }
    //
    // return HeatDataInfo(
    //     heatId: int.parse(heatData.id!), heatName: heatData.heatName, desc: heatData.heat_title, heatDance: heatData.heat_title_short, isFormation: isFormation, participants: shMap);
    return HeatDataInfo();
  }

  //update heat status from job panel list
  void updateHeatStatus(int? heatIndex, bool isStarted, {int? jobPanelId}) {
    //jobpanelheatrow widget have access on jobpanel id, for easy searching of heat
    //if no jobpanel id has been passed, can do a deep search
    if (jobPanelId != null) {
      // LoadJobPanel.jobPanels![jobPanelId - 1].heats!
      //     .firstWhere((element) => element.id == heatIndex.toString())
      //     .isStarted = isStarted;
    } else {
      for (var i = 0; i < LoadJobPanel.jobPanels!.length; i++) {
        // LoadJobPanel.jobPanels?[i].heats
        //     ?.firstWhereOrNull(
        //       (element) => element.id == heatIndex.toString(),
        //     )
        //     ?.isStarted = isStarted;
      }
    }
  }

  HeatData _searchHeatData(int heatId) {
    HeatData? heatData = null;
    //print("HeatId[$heatId] BEFORE For loop jobPanels ================================== ${LoadJobPanel.jobPanels}");
    for (var i = 0; i < LoadJobPanel.jobPanels!.length; i++) {
      //print("INSIDE For loop jobPanels ==================================");
      for (var ht in LoadJobPanel.jobPanels![i].heats!) {
        //print("$ht [${ht?.id}]");
      }
      /*heatData = LoadJobPanel.jobPanels[i].heats?.firstWhereOrNull(
          (heat) => (heat?.id != null && heat.id == heatId.toString()));
      //print("heatData[$heatData] null check ==================================");
      if (heatData != null) {
        break;
      }*/
      //print("heatData [$heatData] ==================================");
    }
    return heatData!;
  }

  void updateCoupleScratchEntryId(String entryId, int status) {
    print("entryId: $entryId Status: $status");
    LoadJobPanel.jobPanels!.forEach((jobPanel) {
      jobPanel.heats!.forEach((heats) {
        // heats.sub_heats!.forEach((subHeat) {
        //   subHeat.couples!.forEach((coupl) {
        //     if(coupl.entry_id == entryId){
        //       //print("heat: ${heats.toMap()}");
        //       //print("subHeatCouple: [${coupl.id}] key:${coupl.couple_key}");
        //       print("coupl: ${coupl.toMap()}");
        //       coupl.is_scratched = (status == 2) ? true : false;
        //       PiContentDao.updateEntryStatusByEntryId(entryId, status);
        //     }
        //   });
        //   /*subHeat.couples!
        //       .firstWhere(
        //         (couple) => couple.id == entryId,
        //   )
        //       .is_scratched = (status == 2) ? true : false;*/
        // });
      });
    });
  }

  Future updateManageEntryResponse(ManageEntry manageEntry) async {
    await manageNewEntry(manageEntry);
  }

  getPrimaryUri() {
    if (DeviceConfig.primary == "rpi1") {
      return DeviceConfig.rpi1;
    } else {
      return DeviceConfig.rpi2;
    }
  }

  Future manageNewEntry(ManageEntry manageEntry) async {
    String protocol = "http://";
    List<HeatCouple> heatCouples = [];
    //get data first from PI
    var heatDataFromPi = await HttpUtil.getRequest(
        "${protocol + getPrimaryUri()}/uberPlatform${manageEntry.cacheURL}");
    //map data
    if (heatDataFromPi is Map<String, dynamic>) {
      //heatdata
      //HeatData heatData = HeatData.fromPi(heatDataFromPi["heat"]);
      //couples in the entire heat
      var hCouples = heatDataFromPi["couples"];
      //print("hCouples: ${hCouples}");
      if (hCouples != null) {
        for (var i = 0; i < hCouples.length; i++) {
          // HeatCouple hc = HeatCouple.fromPi(hCouples[i], "", "", "");
          // //print("HEAT COUPLE fromPi: ${hc.toMap()}");
          // hc.participant1 = CouplePerson.fromPi(hCouples[i]["persons"][0]);
          // hc.participant2 = CouplePerson.fromPi(hCouples[i]["persons"][1]);
          // //print("HEAT COUPLE after change: ${hc.toMap()}");
          // heatCouples.add(hc);
        }
      }
      //subheats
      //heatData.sub_heats = [];
      var heatSubHeat = heatDataFromPi["heat"]["subheats"];
      //print("subHeat from uri: ${heatSubHeat}");
      if (heatSubHeat != null) {
        for (var i = 0; i < heatSubHeat?.length; i++) {
          SubHeatData subHeatData;
          subHeatData = SubHeatData.fromPi(heatSubHeat[i]);
          //print("subHeatData fromPi: ${subHeatData.toMap()}");
          //entries + couples in subheat
          subHeatData.couples = [];
          var shEntries = heatSubHeat[i]["entries"];
          //print("shEntries: ${shEntries}");
          if (shEntries != null) {
            for (var i = 0; i < shEntries?.length; i++) {
              // HeatCouple? couple = heatCouples.firstWhereOrNull(
              //         (e) => e.couple_key == shEntries[i]["entryKey"]);
              // if (couple != null) {
              //   couple.sub_heat_id = subHeatData.id;
              //   couple.couple_level = subHeatData.sub_title;
              //   couple.age_category = subHeatData.sub_heat_age;
              //   subHeatData.couples?.add(couple);
              // }
            }
          }
          if (subHeatData.id == manageEntry.subHeatId) {
            //print("SubHeatData: ${subHeatData.toMap()}");
            pasteSubHeat(1, "${manageEntry.heatId}", subHeatData);
            //heatData.sub_heats?.add(subHeatData);
            //print("PASTE SUBHEAT DONE...");
          }
        }
      }
    }
  }

  void updateCoupleScratch(int? jobPanelId, int? heatId, bool isScratched,
      String? subHeatId, String? coupleId, String? processType) {
    if (processType == "this_heat") {
      // LoadJobPanel.jobPanels![jobPanelId! - 1].heats![heatId! - 1].sub_heats!
      //     .firstWhere((subHeat) => subHeat.id == subHeatId)
      //     .couples!
      //     .firstWhere((couple) => couple.id == coupleId)
      //     .is_scratched = isScratched;
    } else {
      LoadJobPanel.jobPanels!.forEach((jobPanel) {
        jobPanel.heats!.forEach((heats) {
          // heats.sub_heats!.forEach((subHeat) {
          //   subHeat.couples!
          //       .firstWhere(
          //         (couple) => couple.id == coupleId,
          //         //orElse: () => null
          //       )
          //       .is_scratched = isScratched;
          // });
        });
      });
    }
  }

  void pasteSubHeat(int jobPanelId, String heatId, SubHeatData subHeatData) {
    int jpIndex = -1;
    int heatIndex = -1;
    int subHeatIndex = -1;
    jpIndex = LoadJobPanel.jobPanels
        .indexWhere((jp) => jp.id == jobPanelId.toString());
    if (jpIndex != -1) {
      heatIndex = LoadJobPanel.jobPanels[jpIndex].heats
              ?.indexWhere((h) => h.id == heatId) ??
          -1;
      if (heatIndex != -1) {
        // subHeatIndex = LoadJobPanel
        //     .jobPanels[jpIndex].heats?[heatIndex].sub_heats
        //     ?.indexWhere((sh) => sh.id == subHeatData.id) ??
        //     -1;
        if (subHeatIndex != -1) {
          // LoadJobPanel.jobPanels[jpIndex].heats?[heatIndex]
          //     .sub_heats?[subHeatIndex] = subHeatData;
        } else {
          //new subheat
          // LoadJobPanel.jobPanels[jpIndex].heats?[heatIndex].sub_heats
          //     ?.add(subHeatData);
        }
      }
    }
  }
}
