import 'package:intl/intl.dart';

final format = DateFormat("yyyy/MM/dd hh:mm:ss a");

class HeatSequence {
  int? doneHeat;
  int? currentHeat;
  int? currentHeatStatus;
  int? nextHeat;

  String? doneHeatNameL1;
  String? doneHeatNameL2;
  String? doneDanceName;
  String? doneHeatType;
  String? doneDanceShort;
  String? currentHeatNameL1;
  String? currentHeatNameL2;
  String? currentDanceName;
  String? currentHeatType;
  String? currentDanceShort;
  String? nextHeatNameL1;
  String? nextHeatNameL2;
  String? nextDanceName;
  String? nextHeatType;
  String? nextDanceShort;

  int? danceLength;
  int? roomNumber;
  bool? start;
  DateTime? timeStamp;

  HeatSequence(
      {this.doneHeat, this.currentHeat, this.currentHeatStatus, this.nextHeat,
        this.doneHeatNameL1, this.doneHeatNameL2, this.doneHeatType, this.doneDanceName, this.doneDanceShort,
        this.currentHeatNameL1, this.currentHeatNameL2, this.currentDanceName, this.currentHeatType, this.currentDanceShort,
        this.nextHeatNameL1, this.nextHeatNameL2, this.nextDanceName, this.nextHeatType, this.nextDanceShort,
        this.danceLength, this.start, this.timeStamp, this.roomNumber
      });

  HeatSequence.fromMap(Map<String, dynamic> map) {
    doneHeat = map['doneHeat'];
    currentHeat = map['currentHeat'];
    currentHeatStatus = map['status'];
    nextHeat = map['nextHeat'];

    doneHeatNameL1 = map["doneHeatNameL1"];
    doneHeatNameL2 = map["doneHeatNameL2"];
    doneDanceName = map["doneDanceName"];
    doneHeatType = map["doneHeatType"];
    doneDanceShort = map["doneDanceShort"];
    currentHeatNameL1 = map["currentHeatNameL1"];
    currentHeatNameL2 = map["currentHeatNameL2"];
    currentDanceName = map["currentDanceName"];
    currentHeatType = map["currentHeatType"];
    currentDanceShort = map["currentDanceShort"];
    nextHeatNameL1 = map["nextHeatNameL1"];
    nextHeatNameL2 = map["nextHeatNameL2"];
    nextDanceName = map["nextDanceName"];
    nextHeatType = map["nextHeatType"];
    nextDanceShort = map["nextDanceShort"];
    danceLength = map["danceLength"];
    start = map["start"];
    roomNumber = map["roomNumber"];
    if(map["timeStamp"] != null && map["timeStamp"].toString().isNotEmpty) {
      String timeStampStr = map["timeStamp"];
      timeStamp = format.parse(timeStampStr);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'doneHeat': doneHeat,
      'currentHeat': currentHeat,
      'status': currentHeatStatus,
      'nextHeat': nextHeat,

      "doneHeatNameL1": doneHeatNameL1,
      "doneHeatNameL2": doneHeatNameL2,
      "doneDanceName": doneDanceName,
      "doneHeatType": doneHeatType,
      "doneDanceShort": doneDanceShort,
      "currentHeatNameL1": currentHeatNameL1,
      "currentHeatNameL2": currentHeatNameL2,
      "currentDanceName": currentDanceName,
      "currentHeatType": currentHeatType,
      "currentDanceShort": currentDanceShort,
      "nextHeatNameL1": nextHeatNameL1,
      "nextHeatNameL2": nextHeatNameL2,
      "nextDanceName": nextDanceName,
      "nextHeatType": nextHeatType,
      "nextDanceShort": nextDanceShort,
      "danceLength": danceLength,
      "roomNumber": roomNumber,
      "start": start,
      "timeStamp": (timeStamp != null ) ? format.format(timeStamp!) : "",
    };
  }
}
