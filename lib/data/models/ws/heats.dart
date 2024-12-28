// class Heats {
//   String heatId;
//   String heatDesc;

//   Heats(this.heatId, this.heatDesc);

//   Heats.fromJson(Map<String, dynamic> json) {
//     heatId:
//     json['heatId'];
//     heatDesc:
//     json['heatDesc'];
//   }
// }

class Heats {
  Heats({
    this.heatId,
    this.heatDesc,
  });

  int? heatId;
  String? heatDesc;

  factory Heats.fromJson(Map<String, dynamic> json) => Heats(
        heatId: json["heatId"],
        heatDesc: json["heatDesc"],
      );

  Map<String, dynamic> toJson() => {
        "heatId": heatId,
        "heatDesc": heatDesc,
      };
}
