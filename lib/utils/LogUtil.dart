import 'package:flutter_logs/flutter_logs.dart';

class LogUtil {

  // loggerEnabled from Global5Config

  static String tag = "UberDisplay";

  static void logMessage(String message) {
    FlutterLogs.logThis(
        tag: tag,
        subTag: 'general',
        logMessage: message,
        level: LogLevel.INFO);
  }

  static void logMessageInfo(String message, String info) {
    FlutterLogs.logThis(
        tag: tag,
        subTag: info,
        logMessage: message,
        level: LogLevel.INFO);
  }
}