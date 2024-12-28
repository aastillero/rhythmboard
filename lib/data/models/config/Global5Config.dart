import '../Global5.dart';

class Global5Config {
  Global5? _globalFiveSettings;

  Global5Config._privateConstructor();

  static final Global5Config _instance = Global5Config._privateConstructor();

  static Global5? get settings => _instance._globalFiveSettings != null
      ? _instance._globalFiveSettings
      : new Global5();

  static Global5? get globalFiveCopy {
    return _instance._globalFiveSettings = new Global5(
        heatDescription: _instance._globalFiveSettings?.heatDescription,
        heatSelection: _instance._globalFiveSettings?.heatSelection,
        heatAutoNext: _instance._globalFiveSettings?.heatAutoNext,
        danceLength: _instance._globalFiveSettings?.danceLength);
  }

  static set settings(Global5? globalFive) {
    _instance._globalFiveSettings = globalFive;
  }

  static toMap() {
    return {"settings": settings};
  }

  factory Global5Config({Global5? settings}) {
    _instance._globalFiveSettings = settings;
    return _instance;
  }
}
