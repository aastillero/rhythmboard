class DeviceIdentify {
  String? set;

  DeviceIdentify({this.set});

  DeviceIdentify.fromMap(Map<String, dynamic> map) {
    if(map["set"] != null) {
      set = map["set"];
    }
  }

  toMap() {
    return {
      "set": set
    };
  }
}