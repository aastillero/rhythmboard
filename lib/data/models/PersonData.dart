import '../models/enums/UserProfiles.dart';

class PersonData {
  String? id;
  String? job_panel_data_id;
  String? first_name;
  String? last_name;
  String? gender;
  List<String>? initials;
  List<UserProfiles>? user_roles;

  static final String tableName = "person";

  PersonData({this.first_name, this.last_name, this.gender});

  PersonData.fromMap(Map<String, dynamic> map) {
    List<String> _roles = [];
    id = map["id"].toString();
    job_panel_data_id = map["job_panel_data_id"].toString();
    first_name = map["first_name"];
    last_name = map["last_name"];
    gender = map["gender"];
    if (map["initials"] != null) {
      initials = (map["initials"] as String).split("|");
    }
    if (map["user_roles"] != null) {
      _roles = (map["user_roles"] as String).split("|");
    } else {
      _roles = map["user_roles"];
    }
    user_roles = [];
    for (String s in _roles) {
      UserProfiles? _temp = getUserProfilesFromString(s);
      if (_temp != null) {
        user_roles?.add(_temp);
      }
    }
  }

  Map<String, dynamic> toMap() {
    String _temp = "";
    String _userRoles = "";
    if (initials != null && initials!.length > 0) {
      initials!.forEach((v) => _temp += (_temp.isEmpty) ? v : "|" + v);
    }
    if (user_roles != null && user_roles!.length > 0) {
      user_roles!.forEach((v) => _userRoles += (_userRoles.isEmpty)
          ? v.toString().replaceAll("UserProfiles.", "")
          : "|" + v.toString().replaceAll("UserProfiles.", ""));
    }

    return {
      "id": id,
      "job_panel_data_id": job_panel_data_id,
      "first_name": first_name,
      "last_name": last_name,
      "gender": gender,
      "initials": _temp,
      "user_roles": _userRoles,
    };
  }

  @override
  String toString() {
    String _temp = "";
    String _userRoles = "";
    if (initials != null && initials!.length > 0) {
      initials!.forEach((v) => _temp += (_temp.isEmpty) ? v : "|" + v);
    }
    if (user_roles != null && user_roles!.length > 0) {
      user_roles!.forEach((v) => _userRoles += (_userRoles.isEmpty)
          ? v.toString().replaceAll("UserProfiles.", "")
          : "|" + v.toString().replaceAll("UserProfiles.", ""));
    }

    String retVal =
        "{\"id\": $id, \"job_panel_data_id\": $job_panel_data_id, \"first_name\": \"$first_name\", \"last_name\": \"$last_name\", \"gender\": \"$gender\"";
    if (_temp != null) {
      retVal += ", \"initials\": \"$_temp\"";
    }
    if (_userRoles != null) {
      retVal += ", \"user_roles\": \"$_userRoles\"";
    }
    return retVal + "}";
  }
}
