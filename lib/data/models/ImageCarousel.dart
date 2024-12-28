import 'dart:typed_data';

class ImageCarousel {
  int? id;
  int? displayPos;
  String? imgDesc;
  String? filename;
  String? taskId;
  bool enabled = true;
  Uint8List? imgBinary;

  ImageCarousel(
      {this.id,
      this.displayPos,
      this.imgDesc,
      this.enabled = true,
      this.imgBinary});

  ImageCarousel.fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      id = map["imageId"];
      displayPos = map["displayPos"];
      filename = map["filename"];
      taskId = map["taskId"];
      imgDesc = map["description"];
      enabled = map["enabled"];
    }
  }

  toMap() {
    return {
      "id": id,
      "displayPos": displayPos,
      "filename": filename,
      "taskId": taskId,
      "imgDesc": imgDesc,
      "enabled": enabled,
    };
  }
}
