enum JLPTLevel {
  level1("Level 1"),
  level2("Level 2"),
  level3("Level 3"),
  level4("Level 4"),
  level5("Level 5");

  final String value;

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
