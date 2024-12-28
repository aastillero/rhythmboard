import 'package:intl/intl.dart';

class TimeInfo {
  int? hour;
  int? minutes;
  int? seconds;
  int? millis;

  TimeInfo({
    this.hour,
    this.minutes,
    this.seconds,
    this.millis
  });

  TimeInfo.fromMap(Map<String, dynamic> map) {
    hour = map["hour"];
    minutes = map["minute"];
    seconds = map["second"];
    millis = map["millis"];
  }

  Map<String, dynamic> toMap() {
    return {
      "hour": hour,
      "minutes": minutes,
      "seconds": seconds,
      "millis": millis
    };
  }

  @override
  String toString() {
    if(hour == null || minutes == null || seconds == null || millis == null) {
      return "";
    }

    // Convert the hour, minutes, and seconds into a DateTime object
    DateTime dateTime = DateTime(0, 0, 0, hour!, minutes!, seconds!, millis!);

    // Use DateFormat to format the DateTime object
    return DateFormat('h:mm a').format(dateTime);
  }

  DateTime? toDateTime() {
    if(hour == null || minutes == null || seconds == null || millis == null) {
      return null;
    }
    DateTime dateTime = DateTime(0, 0, 0, hour!, minutes!, seconds!, millis!);
    return dateTime;
  }
}