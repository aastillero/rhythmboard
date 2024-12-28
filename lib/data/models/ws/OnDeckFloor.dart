class OnDeckFloor {
  String? entryId;
  bool onDeck = false;
  bool onFloor = false;

  OnDeckFloor({this.entryId, this.onDeck = false, this.onFloor = false});

  OnDeckFloor.fromMap(Map<String, dynamic> map) {
    entryId = map["entryId"].toString();
    onDeck = map["onDeck"];
    onFloor = map["onFloor"];
  }

  toMap() {
    return {
      "entryId": entryId,
      "onDeck": onDeck.toString(),
      "onFloor": onFloor.toString(),
    };
  }
}
