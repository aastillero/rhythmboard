import 'dart:io';
import 'package:battery_info/enums/charging_status.dart';
import 'package:signal_strength/signal_strength.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info/device_info.dart';

class DeviceUtil {
  static var signalStrengthPlugin = SignalStrength();
  static final info = NetworkInfo();

  static Future isOnCellular() async {
    return await signalStrengthPlugin.isOnCellular();
  }

  static Future isOnWifi() async {
    return await signalStrengthPlugin.isOnWifi();
  }

  static Future wifiStrength() async {
    return await signalStrengthPlugin.getWifiSignalStrength();
  }

  static Future batteryLevel() async {
    return (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel;
  }

   static Future<ChargingStatus?> chargingStatus() async {
    return (await BatteryInfoPlugin().androidBatteryInfo)!.chargingStatus;
   }

   static Future isPlugged() async {
    return chargingStatus() == ChargingStatus.Charging;
   }

   static Future getIP() async {
    return await info.getWifiIP();
   }

   static Future getDeviceId() async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor; //UUID for iOS
      }
    } catch(e) {
      print('Failed to get platform version');
    }
   }
}