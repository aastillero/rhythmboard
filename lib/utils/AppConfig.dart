import 'dart:convert' show json;
import 'package:flutter/services.dart';

class AppConfig {
  static String? contactEmail;
  static String? accessCode;
  static String? configCode;
  static String? appVersion;

  static getConfigs() async {
    String data = await rootBundle.loadString('assets/conf/conf.json');
    var result = json.decode(data);
    // String config_val = result[configName];
    // return config_val;
    contactEmail = result["contact_email"] ?? '';
    accessCode = result["app_access_code"] ?? '';
    configCode = result["app_config_code"] ?? '';
    appVersion = result["app_version"] ?? '';
  }
}
