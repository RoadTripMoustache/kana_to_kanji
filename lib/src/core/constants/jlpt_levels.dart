import "package:flutter/material.dart";

abstract class JLPTLevelColors {
  static const Color n5 = Color(0xff3498da);
  static const Color n4 = Color(0xff2ecc71);
  static const Color n3 = Color(0xfff1c40f);
  static const Color n2 = Color(0xfff39c13);
  static const Color n1 = Color(0xffe74b3c);

  static Color level(int level) {
    switch (level) {
      case 1:
        return n1;
      case 2:
        return n2;
      case 3:
        return n3;
      case 4:
        return n4;
      case 5:
      default:
        return n5;
    }
  }
}

enum JLPTLevel {
  n1(1),
  n2(2),
  n3(3),
  n4(4),
  n5(5);

  final int value;

  const JLPTLevel(this.value);

  static JLPTLevel getValue(int level) {
    switch (level) {
      case 1:
        return JLPTLevel.n1;
      case 2:
        return JLPTLevel.n2;
      case 3:
        return JLPTLevel.n3;
      case 4:
        return JLPTLevel.n4;
      case 5:
      default:
        return JLPTLevel.n5;
    }
  }

  @override
  String toString() => value.toString();
}
