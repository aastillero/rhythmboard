class Carousel {
  Carousel({this.imageId, this.displayPos, this.enabled = false});

  int? imageId;
  int? displayPos;
  bool enabled = false;

  factory Carousel.fromJson(Map<String, dynamic> json) => Carousel(
      imageId: json['imageId'],
      displayPos: json['displayPos'],
      enabled: json['enabled']);

  Map<String, dynamic> toJson() =>
      {'imageId': imageId, 'displayPos': displayPos, 'enabled': enabled};
}
