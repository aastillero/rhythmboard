import 'dart:async';

import '../data/dao/JobPanelDao.dart';
import '../../data/models/JobPanelData.dart';

class LoadJobPanel {
  static List<JobPanelData> lazyJobPanels = [];
  static List<JobPanelData> jobPanels = [];
  static Map<String, bool> jobPanelToggle = {};
  static Map<String, bool> heatRowToggle = {};
  static Map<String, bool> coupleRowToggle = {};
  //static Stopwatch _watch = Stopwatch();
  static Timer? _t;

  static Future<void> initJobPanelList() async {
    try {
      /*
    BASIC JOB PANEL STRUCTURE
    [List<JobPanelData>]
      children: [List<HeatData>]
     */

      print('getting jobpanels');

      await JobPanelDao.loadAllPanels((JobPanelData jp, isLast) {
        // _watch.stop();
        // var timeSoFar = _watch.elapsedMilliseconds;
        // print(
        //     "islast{$isLast}  Elapsed time{${timeSoFar}ms} Load JobPanels: ${jp.saveMap()}");
        // if (!isLast) {
        //   _watch.reset();
        //   _watch.start();
        // }
        // if (jp != null) {
        //   lazyJobPanels.add(jp);
        // }
        // jobPanelsLazyLoad(isLast);

        if (!jobPanels.contains(jp)) {
          jobPanels.add(jp);
          setToggles();
        }
      });
    } catch (e) {
      //LogUtil.logErrorMsg("initJobPanelList", e.toString());
    }
  }

  static void jobPanelsLazyLoad(bool isLast) {
    if (jobPanels.isEmpty && lazyJobPanels.isNotEmpty) {
      JobPanelData d = new JobPanelData();
      for (JobPanelData jp in lazyJobPanels) {
        d = new JobPanelData(
          time_start: jp.time_start,
          time_end: jp.time_end,
          panel_persons: jp.panel_persons,
          panel_order: jp.panel_order,
          heat_end: jp.heat_end,
          heat_start: jp.heat_start,
        );
        d.id = jp.id;
        d.heats = [];
        // if (jp.heats.length > 14) {
        //   int cnt = 0;
        //   for (HeatData heatData in jp.heats) {
        //     if (cnt < 14) {
        //       d.heats.add(heatData);
        //     } else {
        //       break;
        //     }
        //     cnt++;
        //   }
        // } else {
        //   d.heats = jp.heats;
        // }
        d.heats!.addAll(jp.heats!);
      }
      jobPanels.add(d);
      setToggles();
    } else {
      // lazy load
      if (_t == null && isLast) {
        _t = new Timer(Duration(milliseconds: 500), () {
          print("EXECUTING LAZY LOAD....");
          jobPanels = [];
          jobPanels.addAll(lazyJobPanels);
          setToggles();
        });
      }
    }
  }

  static void setToggles() {
    // for (JobPanelData _j in jobPanels) {
    //   jobPanelToggle[_j.id!] = false;
    //   if (_j.heats != null && _j.heats!.isNotEmpty) {
    //     for (var _h in _j.heats!) {
    //       heatRowToggle[_h.id!] = false;
    //       if (_h.sub_heats != null && _h.sub_heats!.isNotEmpty) {
    //         for (var _sh in _h.sub_heats!) {
    //           //print("---------------subHeat: ${_sh.toMap()}");
    //           for (var _c in _sh.couples!) {
    //             coupleRowToggle[_c.id!] = false;
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
  }
}
