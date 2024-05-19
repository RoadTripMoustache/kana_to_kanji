enum GlossaryTab {
  hiragana(0),
  katakana(1),
  kanji(2),
  vocabulary(3);

  final int value;

  const GlossaryTab(this.value);

  static GlossaryTab getValue(int index) {
    switch (index) {
      case 0:
        return GlossaryTab.hiragana;
      case 1:
        return GlossaryTab.katakana;
      case 2:
        return GlossaryTab.kanji;
      case 3:
        return GlossaryTab.vocabulary;
      default:
        return GlossaryTab.hiragana;
    }
  }
}
