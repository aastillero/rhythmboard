class HeatCouple {
  late int id; // entry ID
  //int subHeatId; // parent sub heat
  //String? entry_id;
  late int entryType; // couple or single
  late int entryId;
  //entry key or couple key
  //entry key for more uniform
  late String entryKey;
  late String category;

  List<Participant> participants = [];
  bool isScratched = false;
  //
  String studioName = "";
  bool onDeck = false;
  bool onFloor = false;
  int booked = 0;
  int danced = 0;
  int future = 0;
  int total = 0;
  // Participant? participant1;
  // Participant? participant2;
  // String? couple_tag; // L-B1
  //String? couple_category;
  //String? couple_level;
  // String? couple_key;
  // String? age_category;
  //String? studio;
  //bool onDeck = false;
  //bool onFloor = false;
  //bool started = false;
  //bool is_scratched = false;
  // couple summary
  // int? booked;
  // int? scratched;
  // int? danced;
  // int? future;
  // int? total;

  static final String tableName = "heat_couple";

  HeatCouple(this.id, this.entryKey, this.entryType, this.entryId,
      {this.participants = const [],
        this.isScratched = false,
        this.onDeck = false,
        this.onFloor = false,
        this.booked = 0,
        this.danced = 0,
        this.future = 0,
        this.total = 0,
        this.studioName = ""});

  HeatCouple.fromMap(Map<String, dynamic> map) {
    // id = map["coupleId"].toString();
    // sub_heat_id = map["subHeatId"].toString();
    // entry_id = map["entryId"].toString();
    // entryType = map["entryType"];
    // //participant1 = new Participant.fromMap(map["participant1"]);
    // //participant2 = new Participant.fromMap(map["participant2"]);
    // couple_tag = map["couple_tag"];
    // couple_level = map["couple_level"];
    // age_category = map["age_category"];
    // studio = map["studio"];
    // is_scratched = (map["is_scratched"] == 1) ? true : false;
    // couple_key = map["couple_key"];
    id = map["coupleId"];
    if(map["heatSummary"] != null) {
      entryKey = map["heatSummary"]["entryKey"];
      category = map["category"] ?? "";
      isScratched = (map["heatSummary"]["isScratched"] == 1);
      booked = map["heatSummary"]["booked"];
      danced = map["heatSummary"]["danced"];
      future = map["heatSummary"]["future"];
      total = map["heatSummary"]["total"];
    }
    else {
      entryKey = map["entryKey"] ?? "";
      category = map["coupleCategory"] ?? "";
      isScratched = (map["isScratched"] == 1);
      booked = map["booked"] ?? 0;
      danced = map["danced"] ?? 0;
      future = map["future"] ?? 0;
      total = map["total"] ?? 0;
    }
  }

// HeatCouple.fromPi(
//     Map<String, dynamic> map, sub_id, subHeatLevel, subHeatAge) {
//   id = map["coupleId"].toString();
//   sub_heat_id = sub_id;
//   couple_tag = map["coupleKey"];
//   couple_level = subHeatLevel;
//   age_category = subHeatAge;
//   //studio = map["studio"];
//   is_scratched = (map["isScratched"] == 1) ? true : false;
//   couple_key = map["coupleKey"];
//   booked = map["booked"];
//   scratched = map["scratched"];
//   danced = map["danced"];
//   future = map["future"];
//   total = map["total"];
//   couple_category = map["category"];
// }

// Map<String, dynamic> toMap() {
//   return {
//     "id": id,
//     "sub_heat_id": sub_heat_id,
//     "participant1": participant1?.toMap(),
//     "participant2": participant2?.toMap(),
//     "couple_tag": couple_tag,
//     "couple_level": couple_level,
//     "couple_key": couple_key,
//     "age_category": age_category,
//     "studio": studio,
//     "is_scratched": is_scratched,
//   };
// }

// Map<String, dynamic> saveMap() {
//   return {
//     "id": id,
//     "sub_heat_id": sub_heat_id,
//     "participant1": participant1?.id,
//     "participant2": participant2?.id,
//     "couple_tag": couple_tag,
//     "couple_level": couple_level,
//     "couple_key": couple_key,
//     "age_category": age_category,
//     "studio": studio,
//     "is_scratched": (is_scratched ? 1 : 0),
//   };
// }

// List<dynamic> saveList() {
//   return [
//     id,
//     sub_heat_id,
//     participant1?.id,
//     participant2?.id,
//     couple_tag,
//     couple_level,
//     couple_key,
//     age_category,
//     studio,
//     is_scratched ? 1 : 0,
//   ];
// }
}

class Participant {
  late int id;
  late String firstName;
  late String lastName;
  late String gender;
  late String personType;
  int studioId = -1;

  static final String tableName = "couple_person";

  Participant(
      this.id, this.firstName, this.lastName, this.gender, this.personType,
      {this.studioId = -1});

  Participant.fromMap(Map<String, dynamic> data) {
    id = data["personId"];
    firstName = data["firstName"];
    lastName = data["lastName"];
    gender = data["gender"];
    personType = data["personType"] ?? "";
    studioId = data["studioId"];
  }

//   Participant.fromMap(Map<String, dynamic> map) {
//     id = map["id"].toString();
//     first_name = map["first_name"];
//     last_name = map["last_name"];
//     gender = map["gender"];
//     if (map["level"] != null) {
//       level = getParticipantLevelromString(map["level"]);
//     }
//     age = map["age"];
//   }

//   Participant.fromPi(Map<String, dynamic> map) {
//     id = map["personId"].toString();
//     first_name = map["firstName"];
//     last_name = map["lastName"];
//     gender = map["gender"];
//     if (map["personType"] != null) {
//       if (map["personType"] == "P")
//         level = ParticipantLevel.PRO;
//       else
//         level = ParticipantLevel.AM;
//     }
//     //age = map["age"];
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "first_name": first_name,
//       "last_name": last_name,
//       "gender": gender,
//       "level": level?.toString().replaceAll("ParticipantLevel.", ""),
//       "age": age,
//     };
//   }

//   List<dynamic> saveMap() {
//     return [
//       id,
//       first_name,
//       last_name,
//       gender,
//       level?.toString().replaceAll("ParticipantLevel.", ""),
//       age,
//     ];
//   }
}
