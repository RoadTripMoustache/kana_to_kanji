import 'package:flutter/material.dart';

abstract class JLPTLevelColors {
  static const Color level5 = Color(0xff3498da);
  static const Color level4 = Color(0xff2ecc71);
  static const Color level3 = Color(0xfff1c40f);
  static const Color level2 = Color(0xfff39c13);
  static const Color level1 = Color(0xffe74b3c);

  static Color level(int level) {
    switch (level) {
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
        return level4;
      case 5:
      default:
        return level5;
    }
  }
}
