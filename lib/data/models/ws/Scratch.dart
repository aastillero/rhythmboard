class Scratch {
  int? status;
  List<int>? entries;

  Scratch({this.status, this.entries});

  Scratch.fromMap(Map<String, dynamic> map) {
    if (map["status"] != null || map["status"] != "null") {
      status = map["status"];
    }
    if (map["entries"] != null) {
      entries = [];
      for (var e in map["entries"]) {
        entries?.add(e);
      }
    }
  }

  toMap() {
    return {
      "status": status,
      "entries": entries,
    };
  }
}
