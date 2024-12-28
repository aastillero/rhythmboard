import 'package:intl/intl.dart';

class EventConfig {
  final DateFormat format = new DateFormat("yyyy-MM-dd HH:mm");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  final DateFormat timeFormat = new DateFormat("HH:mm");
  String _eventName = '';
  DateTime? _eventDate;
  bool _screenTimeout = false;

  EventConfig._privateConstructor();

  static final EventConfig _instance = EventConfig._privateConstructor();

  static String get eventName =>
      _instance._eventName != '' ? _instance._eventName : '';
  static String get eventDate => _instance._eventDate != null
      ? _instance.dateFormat.format(_instance._eventDate!)
      : '';
  static String get eventYear =>
      _instance._eventDate != null ? _instance._eventDate!.year.toString() : '';
  static String get eventTime => _instance._eventDate != null
      ? _instance.timeFormat.format(_instance._eventDate!)
      : '';
  static bool get screenTimeout =>
      _instance._screenTimeout != null ? _instance._screenTimeout : false;

  static set eventName(String evtName) {
    _instance._eventName = evtName;
  }

  static set eventDate(String evtDate) {
    _instance._eventDate = _instance.dateFormat.parse(evtDate);
  }

  static set screenTimeout(bool timeout) {
    _instance._screenTimeout = timeout;
  }

  static set eventTime(String evtTime) {
    print("$eventDate $evtTime");
    _instance._eventDate = _instance.format.parse("$eventDate $evtTime");
    print(_instance._eventDate);
  }

  static toMap() {
    return {
      "eventName": eventName,
      "eventDate": eventDate,
      "eventTime": eventTime.toUpperCase(),
      "screenTimeout": screenTimeout.toString()
    };
  }

  factory EventConfig(String eventName, String eventDate, bool screenTimeout) {
    print("eventDate: $eventDate");
    _instance._eventName = eventName;
    _instance._eventDate = _instance.format.parse(eventDate);
    _instance._screenTimeout = screenTimeout;
    return _instance;
  }
}
