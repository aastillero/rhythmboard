import '../HeatSequence.dart';

class HeatSequenceConfig {
  HeatSequence? _heatSequence;

  ///Variable for checking changes
  ///

  HeatSequenceConfig._privateConstructor();

  static final HeatSequenceConfig _instance =
      HeatSequenceConfig._privateConstructor();

  static set settings(HeatSequence? heatSequence) {
    _instance._heatSequence = heatSequence;
  }

  static HeatSequence? get settings => _instance._heatSequence != null
      ? _instance._heatSequence
      : new HeatSequence();

  static HeatSequence? get heatSequenceCopy {
    return _instance._heatSequence = new HeatSequence(
      doneHeat: _instance._heatSequence?.doneHeat,
      currentHeat: _instance._heatSequence?.currentHeat,
      nextHeat: _instance._heatSequence?.nextHeat,
    );
  }

  static toMap() {
    return {"settings": settings};
  }

  factory HeatSequenceConfig({HeatSequence? heatSequence}) {
    _instance._heatSequence = heatSequence;
    return _instance;
  }
}
