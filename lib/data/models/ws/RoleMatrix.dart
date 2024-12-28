import '../JobPanel.dart';

class RoleMatrix {
  int? id;
  String? description;
  bool judge = false;
  bool scrutineer = false;
  bool emcee = false;
  bool chairman = false;
  bool deck = false;
  bool registrar = false;
  bool musicDj = false;
  bool photosVideo = false;
  bool hairMakeup = false;

  RoleMatrix(
      {this.id,
      this.description,
      this.judge = false,
      this.scrutineer = false,
      this.emcee = false,
      this.chairman = false,
      this.deck = false,
      this.registrar = false,
      this.musicDj = false,
      this.photosVideo = false,
      this.hairMakeup = false});

  RoleMatrix.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    description = map["description"];
    judge = map["judge"];
    scrutineer = map["scrutineer"];
    emcee = map["emcee"];
    chairman = map["chairman"];
    deck = map["deck"];
    registrar = map["registrar"];
    musicDj = map["musicDj"];
    photosVideo = map["photosVideo"];
    hairMakeup = map["hairMakeup"];
  }

  toMap() {
    return {
      "id": id,
      "description": description,
      "judge": judge,
      "scrutineer": scrutineer,
      "emcee": emcee,
      "chairman": chairman,
      "deck": deck,
      "registrar": registrar,
      "musicDj": musicDj,
      "photosVideo": photosVideo,
      "hairMakeup": hairMakeup
    };
  }

  JobPanel toJobPanel() {
    return new JobPanel(
        id: id,
        description: description,
        judge: judge,
        scrutineer: scrutineer,
        emcee: emcee,
        chairman: chairman,
        deck: deck,
        registrar: registrar,
        musicDj: musicDj,
        photosVideo: photosVideo,
        hairMakeup: hairMakeup);
  }
}
