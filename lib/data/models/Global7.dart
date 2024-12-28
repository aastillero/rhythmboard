
class Global7 {
  int wsDisconnectedPing = 15;
  int warningBatteryLevel = 20;
  int warningWifiLevel = 1;
  int pingInterval = 20;
  int monitorGetInterval = 20;
  bool isPlugged = false;

  Global7({this.wsDisconnectedPing = 15, this.warningBatteryLevel = 20,
    this.warningWifiLevel = 1, this.isPlugged = false, this.pingInterval = 20, this.monitorGetInterval = 20});

  Global7.fromMap(Map<String, dynamic> map) {
    wsDisconnectedPing = map["disconnectedPing"];
    warningBatteryLevel = map["batteryLevel"];
    warningWifiLevel = map["wifiLevel"];
    isPlugged = map["devicePlugged"];
    pingInterval = map["pingInterval"];
    if(map["monitorGetInterval"] != null) {
      monitorGetInterval = map["monitorGetInterval"];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'disconnectedPing': wsDisconnectedPing,
      'batteryLevel': warningBatteryLevel,
      'wifiLevel': warningWifiLevel,
      'devicePlugged': isPlugged,
      'pingInterval': pingInterval,
      'monitorGetInterval': monitorGetInterval,
    };
  }
}