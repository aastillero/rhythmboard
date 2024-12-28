class ParticipantInfo {
  String? participant;
  bool? isScratched;
  String? subHeatName;
  String? subHeatId;
}

class HeatDataInfo {
  int? heatId;
  String? heatName;
  String? heatDance;
  String? heatTitle;
  String? heatTitleShort;
  String? desc;
  String? type;
  bool? isFormation;
  Map<String, List<ParticipantInfo>>? participants;
  HeatDataInfo({this.heatId, this.heatName, this.heatDance, this.heatTitle, this.heatTitleShort, this.desc, this.type, this.participants, this.isFormation});
}
