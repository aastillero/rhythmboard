import 'dart:convert' show json;
import 'package:flutter/services.dart';

class ConfigUtil {

  static Future getConfig(String configName) async {
    String data = await rootBundle.loadString('assets/conf/conf.json');
    var result = json.decode(data);
    String config_val = result[configName];
    return config_val;
  }
}