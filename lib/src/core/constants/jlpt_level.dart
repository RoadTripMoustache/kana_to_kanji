enum JLPTLevel {
  level1(1),
  level2(2),
  level3(3),
  level4(4),
  level5(5);

  final int value;

  const JLPTLevel(this.value);

  static JLPTLevel getValue(int level) {
    switch (level) {
      case 1:
        return JLPTLevel.level1;
      case 2:
        return JLPTLevel.level2;
      case 3:
        return JLPTLevel.level3;
      case 4:
        return JLPTLevel.level4;
      case 5:
      default:
        return JLPTLevel.level5;
    }
  }
}
