import '../Global5.dart';
import '../Global6.dart';
import '../HeatSequence.dart';
import '../config/HeatSequenceConfig.dart';
import '../ManageEntry.dart';

import 'OnDeckFloor.dart';
import 'Scratch.dart';
import 'Started.dart';
import 'Summary.dart';
import 'RoleMatrix.dart';
import 'DeviceIdentify.dart';

class EntryData {
  OnDeckFloor? onDeckFloor;
  Scratch? scratch;
  Started? started;
  RoleMatrix? roleMatrix;
  List<Summary>? summary;
  Global5? global5;
  Global6? global6;
  ManageEntry? manageEntry;
  DeviceIdentify? deviceIdentify;

  EntryData({this.onDeckFloor, this.scratch, this.started});

  EntryData.fromMap(Map<String, dynamic> map) {
    if (map["onDeckFloor"] != null) {
      onDeckFloor = new OnDeckFloor.fromMap(map["onDeckFloor"]);
    }
    if (map["ondeckfloor"] != null) {
      onDeckFloor = new OnDeckFloor.fromMap(map["ondeckfloor"]);
    }
    if (map["scratch"] != null) {
      scratch = new Scratch.fromMap(map["scratch"]);
    }
    if (map["started"] != null) {
      started = new Started.fromMap(map["started"]);
    }
    print("heatStatus: ${map["heatStatus"]}");
    if (map["heatStatus"] != null) {
      HeatSequence seq = HeatSequence.fromMap(map["heatStatus"]);
      HeatSequenceConfig(heatSequence: seq);
      //HeatSequenceConfig.heatNotifer.value = seq;
    }
    if (map["summary"] != null && map["summary"].length > 0) {
      var _summary = map["summary"];
      summary = [];
      for (var s in _summary) {
        summary?.add(new Summary.fromMap(s));
      }
    }
    if (map["roleMatrix"] != null && map["roleMatrix"]["rolematrix"] != null) {
      roleMatrix = new RoleMatrix.fromMap(map["roleMatrix"]["rolematrix"]);
    }
    if (map["globalFive"] != null) {
      global5 = new Global5.fromMap(map["globalFive"]);
    }
    if (map["globalSix"] != null) {
      global6 = new Global6.fromMap(map["globalSix"]);
    }
    if (map["manageEntry"] != null) {
      try {
        Map<String, dynamic> mapHolder = map["manageEntry"];
        if (mapHolder["retcode"] == 0) {
          manageEntry = ManageEntry.fromMap(mapHolder);
        }
      } catch (e) {
        print('error: entry data - ManageEntry message: $e');
      }
    }
    if (map["deviceIdentify"] != null) {
      deviceIdentify = DeviceIdentify.fromMap(map["deviceIdentify"]);
    }
  }

  toMap() {
    return {
      "onDeckFloor": onDeckFloor?.toMap(),
      "scratch": scratch?.toMap(),
      "started": started?.toMap(),
      "summary": summary?.map((s) => s.toMap()),
    };
  }
}
