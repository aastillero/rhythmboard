class ManageEntry {
  late int entryId;
  late int heatId;
  late String subHeatId;
  late int entryType;
  late String entryKey;
  late String personKey1;
  late String personKey2;
  late String cacheURL;

  ManageEntry.fromMap(Map<String, dynamic> data) {
    entryId = data["entryId"];
    heatId = data["entry"]["heatId"];
    cacheURL = data["heatURL"];
    subHeatId = data["entry"]["subHeatId"];
    entryType = data["entry"]["entryType"];
    entryKey = data["entry"]["entryKey"];
    personKey1 = data["entry"]["personKey1"] ?? "";
    personKey2 = data["entry"]["personKey2"] ?? "";
  }
  Map<String, dynamic> toMap() => {
        "entryId": entryId,
        "heatId": heatId,
        "subHeatId": subHeatId,
        "entryType": entryType,
        "entryKey": entryKey,
        "personKey1": personKey1,
        "personKey2": personKey2
      };
}
