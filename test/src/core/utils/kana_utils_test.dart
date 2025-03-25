import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class SplitBySyllableTestCase {
  final String name;
  final String input;
  final List<int> expectedResult;

  SplitBySyllableTestCase(this.name, this.input, this.expectedResult);
}

class SortBySyllableTestCase {
  final String name;
  final List<int> syllablesA;
  final List<int> syllablesB;
  final int expectedResult;

  SortBySyllableTestCase(
    this.name,
    this.syllablesA,
    this.syllablesB,
    this.expectedResult,
  );
}

void main() {
  group("splitBySyllable", () {
    final List<SplitBySyllableTestCase> cases = [
      SplitBySyllableTestCase("One hiragana", "あ", [0]),
      SplitBySyllableTestCase("One katakana", "ア", [1]),
      SplitBySyllableTestCase("One hiragana & katakana", "あア", [0, 1]),
      SplitBySyllableTestCase("Word with a `ー`", "あー", [0, 0]),
      SplitBySyllableTestCase("Word with a `っ`", "がっこう", [11, 38, 38, 4]),
      SplitBySyllableTestCase("Hiragana combination", "きょ", [14, 195]),
      SplitBySyllableTestCase("Katakana combination", "キョ", [22, 197]),
    ];
    for (final SplitBySyllableTestCase testCase in cases) {
      test(testCase.name, () {
        final List<int> result = splitBySyllable(testCase.input);

        expect(testCase.expectedResult, result);
      });
    }
  });

  group("sortBySyllables", () {
    final List<SortBySyllableTestCase> cases = [
      SortBySyllableTestCase(
        "あ - ア",
        [jpOrder.indexOf("あ")],
        [jpOrder.indexOf("ア")],
        -1,
      ),
      SortBySyllableTestCase(
        "ア - あ",
        [jpOrder.indexOf("ア")],
        [jpOrder.indexOf("あ")],
        1,
      ),
      SortBySyllableTestCase(
        "あ - あ",
        [jpOrder.indexOf("あ")],
        [jpOrder.indexOf("あ")],
        0,
      ),
      SortBySyllableTestCase(
        "ア - ア",
        [jpOrder.indexOf("ア")],
        [jpOrder.indexOf("ア")],
        0,
      ),
      SortBySyllableTestCase(
        "ああ - あア",
        [jpOrder.indexOf("あ"), jpOrder.indexOf("あ")],
        [jpOrder.indexOf("あ"), jpOrder.indexOf("ア")],
        -1,
      ),
      SortBySyllableTestCase(
        "あア - ああ",
        [jpOrder.indexOf("あ"), jpOrder.indexOf("ア")],
        [jpOrder.indexOf("あ"), jpOrder.indexOf("あ")],
        1,
      ),
      SortBySyllableTestCase(
        "あああ - ああ",
        [jpOrder.indexOf("あ"), jpOrder.indexOf("あ"), jpOrder.indexOf("あ")],
        [jpOrder.indexOf("あ"), jpOrder.indexOf("あ")],
        1,
      ),
      SortBySyllableTestCase(
        "がここきょ - がここキキ",
        [
          jpOrder.indexOf("が"),
          jpOrder.indexOf("こ"),
          jpOrder.indexOf("こ"),
          jpOrder.indexOf("き"),
          jpOrder.indexOf("ょ"),
        ],
        [
          jpOrder.indexOf("が"),
          jpOrder.indexOf("こ"),
          jpOrder.indexOf("こ"),
          jpOrder.indexOf("キ"),
          jpOrder.indexOf("キ"),
        ],
        -1,
      ),
    ];
    for (final SortBySyllableTestCase testCase in cases) {
      test(testCase.name, () {
        final int result = sortBySyllables(
          testCase.syllablesA,
          testCase.syllablesB,
        );

        expect(testCase.expectedResult, result);
      });
    }
  });
}
