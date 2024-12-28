//{"entryKey":"106-01","booked":48,"scratched":1,"danced":10,"future":37,"total":47}

class Summary {
  String? entryKey;
  int? booked;
  int? scratched;
  int? danced;
  int? future;
  int? total;

  Summary(
      {this.entryKey,
      this.booked,
      this.scratched,
      this.danced,
      this.future,
      this.total});

  Summary.fromMap(Map<String, dynamic> map) {
    if (map["entryKey"] != null || map["entryKey"] != "null") {
      entryKey = map["entryKey"];
    }
    if (map["booked"] != null) {
      booked = map["booked"];
    }
    if (map["scratched"] != null) {
      scratched = map["scratched"];
    }
    if (map["danced"] != null) {
      danced = map["danced"];
    }
    if (map["future"] != null) {
      future = map["future"];
    }
    if (map["total"] != null) {
      total = map["total"];
    }
  }

  toMap() {
    return {
      "entryKey": entryKey,
      "booked": booked,
      "scratched": scratched,
      "danced": danced,
      "future": future,
      "total": total
    };
  }
}
