class Started {
  bool started = false;
  int? heatId;
  int? nextHeatId;
  int? nextHeatIdPlus;

  Started(
      {this.started = false,
      this.heatId,
      this.nextHeatId,
      this.nextHeatIdPlus});

  Started.fromMap(Map<String, dynamic> map) {
    if (map["started"] != null || map["started"] != "null") {
      started = map["started"];
    }
    if (map["heatId"] != null) {
      heatId = map["heatId"];
    }
    if (map["nextHeatId"] != null) {
      nextHeatId = map["nextHeatId"];
    }
    if (map["nextHeatIdPlus"] != null) {
      nextHeatIdPlus = map["nextHeatIdPlus"];
    }
  }

  toMap() {
    return {
      "started": started,
      "heatId": heatId,
      "nextHeatId": nextHeatId,
      "nextHeatIdPlus": nextHeatIdPlus,
    };
  }
}
