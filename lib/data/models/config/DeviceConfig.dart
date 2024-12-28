class DeviceConfig {
  String? _deviceUID;
  String? _deviceName;
  String? _deviceIp;
  String? _mask;
  String? _rpi1;
  String? _rpi2;
  bool _rpi1Enabled = false;
  bool _rpi2Enabled = false;
  String? _primary;

  DeviceConfig._privateConstructor();

  static final DeviceConfig? _instance = DeviceConfig._privateConstructor();

  static String? get deviceUID =>
      _instance!._deviceUID != null ? _instance!._deviceUID : '';
  static String? get deviceName =>
      _instance!._deviceName != null ? _instance!._deviceName : '';
  static String? get deviceIp =>
      _instance!._deviceIp != null ? _instance!._deviceIp : '';
  static String? get mask => _instance!._mask != null ? _instance!._mask : '';
  static String? get rpi1 => _instance!._rpi1 != null ? _instance!._rpi1 : '';
  static String? get rpi2 => _instance!._rpi2 != null ? _instance!._rpi2 : '';
  static String? get primary =>
      _instance!._primary != null ? _instance!._primary : '';
  static bool get rpi1Enabled =>
      _instance?._rpi1Enabled != null ? _instance!._rpi1Enabled : false;
  static bool get rpi2Enabled =>
      _instance?._rpi2Enabled != null ? _instance!._rpi2Enabled : false;

  static set deviceUID(String? uid) {
    _instance!._deviceUID = uid;
  }

  static set deviceName(String? name) {
    _instance!._deviceName = name;
  }

  static set deviceIp(String? ip) {
    _instance!._deviceIp = ip;
  }

  static set mask(String? m) {
    _instance!._mask = m;
  }

  static set rpi1(String? r) {
    _instance!._rpi1 = r;
  }

  static set rpi2(String? r) {
    _instance!._rpi2 = r;
  }

  static set primary(String? p) {
    _instance!._primary = p;
  }

  static set rpi1Enabled(bool r) {
    _instance!._rpi1Enabled = r;
  }

  static set rpi2Enabled(bool r) {
    _instance!._rpi2Enabled = r;
  }

  static Map<String,dynamic>toMap() {
    return {
      "deviceUID": deviceUID,
      "deviceName": deviceName,
      "deviceIp": deviceIp,
      "mask": mask,
      "rpi1": rpi1,
      "rpi1Enabled": rpi1Enabled,
      "rpi2": rpi2,
      "rpi2Enabled": rpi2Enabled,
      "primary": primary
    };
  }

  factory DeviceConfig(
      {String deviceUID = '',
        String deviceName = '',
        String rpi1 = '',
        String rpi2 = '',
        String deviceIp = '',
        String mask = '',
        String primary = '',
        bool rpi1Enabled = false,
        bool rpi2Enabled = false}) {
    _instance!._deviceUID = deviceUID;
    _instance!._deviceName = deviceName;
    _instance!._rpi1 = rpi1;
    _instance!._rpi2 = rpi2;
    _instance!._deviceIp = deviceIp;
    _instance!._mask = mask;
    _instance!._primary = primary;
    _instance!._rpi1Enabled = rpi1Enabled;
    _instance!._rpi2Enabled = rpi2Enabled;
    return _instance!;
  }
}