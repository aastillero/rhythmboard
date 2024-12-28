class Global5 {
  String? heatDescription;
  String? heatSelection;
  String? heatAutoNext;
  int? danceLength;

  Global5(
      {this.heatDescription,
      this.heatSelection,
      this.heatAutoNext,
      this.danceLength});

  Global5.fromMap(Map<String, dynamic> map) {
    heatDescription = map['heatDescription'];
    heatSelection = map['heatSelection'];
    heatAutoNext = map['heatAutoNext'];
    danceLength = int.tryParse(map['danceLength']);
  }

  Map<String, dynamic> toMap() {
    return {
      'heatDescription': heatDescription,
      'heatSelection': heatSelection,
      'heatAutoNext': heatAutoNext,
      "danceLength": danceLength
    };
  }
}
