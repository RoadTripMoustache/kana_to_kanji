const List<String> jpOrder = [
  "あ", "ア",
  "い", "イ",
  "う", "ウ",
  "え", "エ",
  "お", "オ",
  "か", "が", "カ","ガ",
  "き", "きゃ", "きゅ", "きょ", "ぎ", "ぎゃ", "ぎゅ", "ぎょ", "キ", "キャ", "キュ", "キョ", "ギ", "ギャ", "ギュ", "ギョ",
  "く", "ぐ", "ク", "グ",
  "け", "げ", "ケ", "ゲ",
  "こ", "ご", "コ", "ゴ",
  "さ", "ざ", "サ", "ザ",
  "し", "しゃ", "しゅ", "しゅ", "じ", "じゃ", "じゅ", "じょ", "シ", "シャ", "シュ", "ショ", "ジ", "ジャ", "ジュ", "ジョ",
  "す", "ず", "ス", "ズ",
  "せ", "ぜ", "セ", "ゼ",
  "そ","ぞ", "ソ", "ゾ",
  "た", "だ", "タ", "ダ",
  "ち", "ちゃ", "ちゅ", "ちょ", "ぢ", "チ", "チャ", "チュ", "チョ", "ヂ", "ヂャ", "ヂュ", "ヂョ",
  "つ", "づ", "ツ", "ヅ",
  "て", "で", "テ",  "デ",
  "と","ど",  "ト","ド",
  "な", "ナ",
  "に", "にゃ", "にゅ", "にょ", "ニ", "ニャ", "ニュ", "ニョ",
  "ぬ", "ヌ",
  "ね", "ネ",
  "の", "ノ",
  "は", "ば", "ぱ", "ハ", "バ", "パ",
  "ひ", "ひゃ", "ひゅ", "ひょ", "び", "びゃ", "びゅ", "びょ", "ぴ", "ぴゃ", "ぴゅ", "ぴょ", "ヒ", "ヒャ", "ヒュ", "ヒョ", "ビ", "ビャ", "ビュ", "ビョ", "ピ", "ピャ", "ピュ", "ピョ",
  "ふ", "ぶ", "ぷ", "フ", "ブ", "プ",
  "へ", "べ", "ぺ", "ヘ", "ベ", "ペ",
  "ほ","ぼ","ぽ", "ホ", "ボ", "ポ",
  "ま", "マ",
  "み", "みゃ", "みゅ", "みょ", "ミ", "ミャ", "ミュ", "ミョ",
  "む", "ム",
  "め", "メ",
  "も", "モ",
  "や", "ヤ",
  "ゆ", "ユ",
  "よ", "ヨ",
  "ら", "ラ",
  "り", "りゃ", "りゅ", "りょ", "リ", "リャ", "リュ", "リョ",
  "る", "ル",
  "れ", "レ",
  "ろ", "ロ",
  "わ", "ワ",
  "を", "ヲ",
  "ん", "ン"
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
