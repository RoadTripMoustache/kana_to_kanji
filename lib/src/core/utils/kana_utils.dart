const List<String> jpOrder = [
  "あ", "い", "う", "え", "お",
  "か", "が", "き", "きゃ", "きゅ", "きょ", "ぎ", "ぎゃ", "ぎゅ", "ぎょ", "く","ぐ", "け","げ", "こ","ご",
  "さ", "ざ", "し", "しゃ", "しゅ", "しゅ", "じ", "じゃ", "じゅ", "じょ", "す", "ず", "せ", "ぜ", "そ","ぞ",
  "た", "だ", "ち", "ちゃ", "ちゅ", "ちょ", "ぢ", "つ", "づ", "て", "で", "と","ど",
  "な", "に", "にゃ", "にゅ", "にょ", "ぬ", "ね", "の",
  "は", "ば", "ぱ", "ひ", "ひゃ", "ひゅ", "ひょ", "び", "びゃ", "びゅ", "びょ", "ぴ", "ぴゃ", "ぴゅ", "ぴょ", "ふ", "ぶ", "ぷ", "へ", "べ", "ぺ", "ほ","ぼ","ぽ",
  "ま", "み", "みゃ", "みゅ", "みょ", "む", "め", "も",
  "や", "ゆ", "よ",
  "ら", "り", "りゃ", "りゅ", "りょ", "る", "れ", "ろ",
  "わ", "を", "ん"

];

List<String> splitBySyllable(String kanaWord) {
  List<String> syllables = kanaWord.split("");

  for (var i=0; i<syllables.length; i++) {
    if (syllables[i] == "ー" && i > 0) {
      syllables[i] = syllables[i - 1];
    }
  }

  return syllables;
}

int sortBySyllables(List<String> syllablesA, List<String> syllablesB) {
  int index = 0;
  while (index < syllablesA.length && index < syllablesB.length) {
    final int comparison =
    jpOrder.indexOf(syllablesA[index].toLowerCase()).compareTo(jpOrder.indexOf(syllablesB[index].toLowerCase()));
    if (comparison != 0) {
      // -1 or +1 means that the letters are different, thus an order is found
      return comparison;
    } // 0 means that the letters are equal, go to next letter
    index++;
  }
  return syllablesA.length.compareTo(syllablesB.length);
}
