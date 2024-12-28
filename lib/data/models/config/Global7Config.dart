import '../Global7.dart';

class Global7Config {
  Global7? _globalSevenSettings;

  Global7Config._privateConstructor();

  static final Global7Config _instance = Global7Config._privateConstructor();

  static Global7? get settings => _instance._globalSevenSettings ?? Global7();

  static Global7 get globalSevenCopy {
    return _instance._globalSevenSettings = Global7(
        wsDisconnectedPing:
            _instance._globalSevenSettings?.wsDisconnectedPing ?? 15,
        isPlugged: _instance._globalSevenSettings?.isPlugged ?? false,
        pingInterval: _instance._globalSevenSettings?.pingInterval ?? 20,
        monitorGetInterval:
            _instance._globalSevenSettings?.monitorGetInterval ?? 20,
        warningBatteryLevel:
            _instance._globalSevenSettings?.warningBatteryLevel ?? 20,
        warningWifiLevel:
            _instance._globalSevenSettings?.warningWifiLevel ?? 1);
  }

  static set settings(Global7? globalSeven) {
    _instance._globalSevenSettings = globalSeven;
  }

  static toMap() {
    return {"settings": settings};
  }

  factory Global7Config({Global7? settings}) {
    _instance._globalSevenSettings = settings;
    return _instance;
  }
}
