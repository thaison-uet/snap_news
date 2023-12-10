import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';

enum CategoryType {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology
}

extension CategoryTypeExtension on CategoryType {
  String get imageName {
    return "assets/images/img_$name.jpeg";
  }

  Color get color {
    switch (this) {
      case CategoryType.business:
        return colorBusinessCover;
      case CategoryType.entertainment:
        return colorEntertainmentCover;
      case CategoryType.general:
        return colorGeneralCover;
      case CategoryType.health:
        return colorHealthCover;
      case CategoryType.science:
        return colorScienceCover;
      case CategoryType.sports:
        return colorSportsCover;
      case CategoryType.technology:
        return colorTechnologyCover;
    }
  }
}
