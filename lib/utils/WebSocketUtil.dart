//import '../model/config/DeviceConfig.dart';
import 'DeviceUtil.dart';
import '../model/ws/WebSocketListener.dart';
import '../websocket/DanceFrameCommunication.dart';

class WebSocketUtil {
  static Map<String, dynamic> _wsObj(Map<String, dynamic> _objData) {
    Map<String, dynamic> retVal = {
      //"deviceName": DeviceConfig.deviceNum,
      "deviceUID": _objData["deviceUID"],
      "broadcast": "all",
      "onDeckFloor": null,
      "scratch": null,
      "started": null,
      "roleMatrix": null,
      "globalFive": null,
      "heatStatus": null,
      "globalSix": null,
      "globalSeven": null,
      "deviceMonitor": null,
      "critique": null,
      "initial": null,
      "setupInitials": null,
      "critiqueWithImage": null,
      "initialsWithImage": null,
      "filedata": null,
      "proficiencyRanking": null,
      "deviceIdentify": null
    };

    retVal.addAll(_objData);
    return retVal;
  }

  static void gameSend(Map<String, dynamic> objData) {
    game.send(_wsObj(objData));
  }

  static addListener(WebSocketListener listener) {
    game.addListener(listener);
  }
}

class WSOperation {
  static const String UpdateRoleMatrix = "update-rolematrix";
  static const String UploadNewInitial = "setup-initials-with-image";
  static const String UploadCritique = "update-critique-with-image";
  static const String UploadRandomInitial = "update-initial";
  static const String UpdateHeatStatus = "update-heatstatus";
  static const String UpdateHeatSummary = "update-heat2summary";
  static const String UpdateGlobalFive = "update-globalfive";
  static const String UpdateGlobalSix = "update-globalsix";
  static const String UpdateGlobalSeven = "update-globalseven";
  static const String UpdateProfRank = "update-proficiency-ranking";
  static const String MonitorRegister = "monitor-register";
  static const String MonitorUpdate = "monitor-update";
  static const String MonitorIdentify = "set-monitor-identify";
}
