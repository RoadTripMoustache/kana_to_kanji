import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_levels.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/glossary/widgets/filter_by.dart';

import '../../../helpers.dart';

class FilterByTestCase {
  final String name;
  final List<JLPTLevel> selectedJlptLevel;
  final List<KnowledgeLevel> selectedKnowledgeLevel;
  final List<int> indexesTrue;

  FilterByTestCase(this.name, this.selectedJlptLevel,
      this.selectedKnowledgeLevel, this.indexesTrue);
}

void main() {
  group("FilterBy", () {
    List<FilterByTestCase> cases = [
      FilterByTestCase("default view", [], [], []),
      FilterByTestCase("JLPT 1 selected", [JLPTLevel.level1], [], [0]),
      FilterByTestCase("JLPT 2 selected", [JLPTLevel.level2], [], [1]),
      FilterByTestCase("JLPT 3 selected", [JLPTLevel.level3], [], [2]),
      FilterByTestCase("JLPT 4 selected", [JLPTLevel.level4], [], [3]),
      FilterByTestCase("JLPT 5 selected", [JLPTLevel.level5], [], [4]),
      FilterByTestCase("Knowledge level 'Learned' selected", [],
          [KnowledgeLevel.learned], [5]),
      FilterByTestCase("Knowledge level 'Practicing' selected", [],
          [KnowledgeLevel.practicing], [6]),
      FilterByTestCase(
          "Knowledge level 'Seen' selected", [], [KnowledgeLevel.seen], [7]),
      FilterByTestCase("Knowledge level 'Never seen' selected", [],
          [KnowledgeLevel.other], [8]),
      FilterByTestCase(
          "Multiple selections",
          [JLPTLevel.level1, JLPTLevel.level4],
          [KnowledgeLevel.other, KnowledgeLevel.practicing],
          [0, 3, 6, 8]),
    ];

    for (FilterByTestCase testCase in cases) {
      testWidgets(testCase.name, (WidgetTester tester) async {
        await tester.pumpLocalizedWidget(FilterBy(
          filterGlossary: () => {},
          selectedJlptLevel: testCase.selectedJlptLevel,
          selectedKnowledgeLevel: testCase.selectedKnowledgeLevel,
        ));
        await tester.pumpAndSettle();

        final checkboxes = find.byType(Checkbox);
        expect(checkboxes, findsNWidgets(9));

        for (int i = 0; i < 9; i++) {
          expect((tester.widget(checkboxes.at(i)) as Checkbox).value,
              testCase.indexesTrue.contains(i) ? isTrue : isFalse);
        }
      });
    }

    testWidgets("Click on close", (WidgetTester tester) async {
      var isClicked = false;
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {isClicked = true},
        selectedJlptLevel: const [JLPTLevel.level1, JLPTLevel.level4],
        selectedKnowledgeLevel: const [
          KnowledgeLevel.other,
          KnowledgeLevel.practicing
        ],
      ));
      await tester.pumpAndSettle();

      final buttons = find.byType(IconButton);
      expect(buttons, findsNWidgets(2));
      expect(isClicked, isFalse);

      await tester.tap(buttons.first);
      expect(isClicked, isTrue);
    });

    testWidgets("Click on clear all", (WidgetTester tester) async {
      var isClicked = false;
      var selectedJlptLevelList = [JLPTLevel.level1, JLPTLevel.level4];
      var selectedKnowledgeLevelList = [
        KnowledgeLevel.other,
        KnowledgeLevel.practicing
      ];
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {isClicked = true},
        selectedJlptLevel: selectedJlptLevelList,
        selectedKnowledgeLevel: selectedKnowledgeLevelList,
      ));
      await tester.pumpAndSettle();

      final buttons = find.byType(IconButton);
      expect(buttons, findsNWidgets(2));
      expect(isClicked, isFalse);

      await tester.tap(buttons.last);
      expect(isClicked, isFalse);
      expect(selectedJlptLevelList.isEmpty, isTrue);
      expect(selectedKnowledgeLevelList.isEmpty, isTrue);
    });
  });
}
