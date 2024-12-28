import '../Global6.dart';

class Global6Config {
  Global6? _globalSixSettings;

  Global6Config._privateConstructor();

  static final Global6Config _instance = Global6Config._privateConstructor();

  static Global6? get settings => _instance._globalSixSettings != null
      ? _instance._globalSixSettings
      : new Global6();

  static Global6 get globalSixCopy {
    return _instance._globalSixSettings = new Global6(
        critiqueFormtype: _instance._globalSixSettings?.critiqueFormtype ?? 1,
        wsReconnectDelay: _instance._globalSixSettings?.wsReconnectDelay ?? 15,
        enableLogger: _instance._globalSixSettings?.enableLogger ?? false);
  }

  static set settings(Global6? globalSix) {
    _instance._globalSixSettings = globalSix;
  }

  static toMap() {
    return {"settings": settings};
  }

  factory Global6Config({Global6? settings}) {
    _instance._globalSixSettings = settings;
    return _instance;
  }
}
