import '../data/models/config/DeviceConfig.dart';
import 'LoadContent.dart';

class ConnectionUtil {
  static getPrimaryUri() {
    //print("GET PRIMARY METHOD");
    if (DeviceConfig.primary == "rpi1") {
      return DeviceConfig.rpi1;
    } else {
      return DeviceConfig.rpi2;
    }
  }

  static getSecondaryUri() {
    // print("GET SECONDARY METHOD");
    print(
        "prim: ${DeviceConfig.primary}  rpi2Enabled: ${DeviceConfig.rpi2Enabled}");
    if (DeviceConfig.primary == "rpi1") {
      return (DeviceConfig.rpi2Enabled) ? DeviceConfig.rpi2 : "";
    } else {
      print("rpi1Enabled: ${DeviceConfig.rpi1Enabled}");
      return (DeviceConfig.rpi1Enabled) ? DeviceConfig.rpi1 : "";
    }
  }

  static Future<bool> validatedTestConnection() async {
    bool retVal = false;
    //validate first if in testConnection endpoint
    String uri = "/uberPlatform/test";
    String rpi1 = getPrimaryUri();
    String rpi2 = getSecondaryUri();
    var resp;
    print("@@ Checking in ${rpi1 + uri}");
    resp = await LoadContent.testConnection(rpi1 + uri);
    if (LoadContent.isSuccess(resp)) {
      retVal = true;
    } else {
      print('@@ Error in $rpi1');
      print("@@ Checking in secondary ${rpi2 + uri}");
      resp = await LoadContent.testConnection(rpi2 + uri);
      if (LoadContent.isSuccess(resp)) {
        retVal = true;
      }
    }

    return retVal;
  }
}
