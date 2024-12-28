import 'dart:convert';

import 'package:intl/intl.dart';

class TimeOutConfig {
  static TimeOutConfig? _instance;
  factory TimeOutConfig() => _instance ??= new TimeOutConfig._();
  TimeOutConfig._();
  String? jobType;
  int? timeOutVal;
  bool enabled = false;
  List<Map<String, dynamic>> list = [];

  String? getJobType(String name) => jobType = name;
  int? getTimeOutValue(dynamic value) =>
      timeOutVal = value == null ? 0 : int.parse(value);
  bool? getEnabled(bool isEnabled) => enabled = isEnabled;
  void getList(Map<String, dynamic> value) => list.add(value);

  toMap() {
    return list;
  }
}
