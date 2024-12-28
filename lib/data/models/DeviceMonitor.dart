
class DeviceMonitor {
  String deviceId = "9ac8bf193bde5f5d1";
  String deviceNo = "";
  String deviceIp = "192.168.0.1.19";
  String deviceApp = "uberTab";
  String deviceRole = "FreeTime";
  int wifi = 10;
  int battery = 20;
  int peopleId = 3;
  bool plugged = false;

  DeviceMonitor({this.deviceId = "9ac8bf193bde5f5d1", this.deviceNo = "", this.deviceIp = "192.168.0.1.19",
    this.deviceApp = "uberTab", this.deviceRole = "FreeTime", this.wifi = 10, this.battery = 20,
    this.peopleId = 3, this.plugged = false
  });

  DeviceMonitor.fromMap(Map<String, dynamic> map) {
    deviceId = map["deviceId"];
    deviceNo = map["deviceName"];
    deviceIp = map["deviceIp"];
    deviceApp = map["deviceApp"];
    deviceRole = map["deviceRole"];
    wifi = map["wifi"];
    battery = map["battery"];
    peopleId = map["peopleId"];
    plugged = map["plugged"];
  }

  Map<String, dynamic> toMap() {
    return {
      "deviceUID": deviceId,
      "deviceName": deviceNo,
      "deviceIp": deviceIp,
      "deviceApp": deviceApp,
      "deviceRole": deviceRole,
      "wifi": wifi,
      "battery": battery,
      "peopleId": peopleId,
      "plugged": plugged
    };
  }
}