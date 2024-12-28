import '../models/TimeInfo.dart';
import '../../utils/LoadContent.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart';

class TimeInfoDao {
  static Future getTimeInfo() async {
    //String data = await rootBundle.loadString('assets/conf/timeconf.json');
    //http://9ad9f00d4fb2.ngrok.io/uberPlatform/servertime
    var data = await LoadContent.httpRequest("/uberPlatform/servertime");
    //print("data.hour [${data["hour"]}]");
    //var result = json.decode(data);
    TimeInfo timeInfo = TimeInfo.fromMap(data);
    //print("timeInfo: ${timeInfo}");
    return timeInfo;
    //print("enpoints: $endpointHeat");
  }
}
