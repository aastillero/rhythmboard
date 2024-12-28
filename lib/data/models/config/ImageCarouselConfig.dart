import '../ImageCarousel.dart';

class ImageCarouselConfig {
  List<ImageCarousel>? imageCarousel;
  ImageCarouselConfig._privateConstructor();

  static final ImageCarouselConfig _instance =
      ImageCarouselConfig._privateConstructor();

  static set settings(List<ImageCarousel>? imageCarousel) {
    _instance.imageCarousel = imageCarousel;
  }

  static List<ImageCarousel>? get settings =>
      _instance.imageCarousel != null ? _instance.imageCarousel : [];

  static List<ImageCarousel>? get imageCarouselCopy {
    return _instance.imageCarousel = [];
  }

  factory ImageCarouselConfig({List<ImageCarousel>? imageCarousel}) {
    _instance.imageCarousel = imageCarousel;
    return _instance;
  }
}
