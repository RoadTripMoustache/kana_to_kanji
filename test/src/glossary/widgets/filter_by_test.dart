import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_level.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/glossary/widgets/filter_by.dart';
import 'package:kana_to_kanji/src/glossary/widgets/search_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers.dart';

void main() {
  group("FilterBy", () {
    testWidgets("Default view", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("JLPT 1 selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level1],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("JLPT 2 selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level2],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("JLPT 3 selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level3],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("JLPT 4 selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level4],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("JLPT 5 selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level5],
        selectedKnowledgeLevel: const [],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("Knowledge level 'Learned' selected",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [],
        selectedKnowledgeLevel: const [KnowledgeLevel.learned],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("Knowledge level 'Practicing' selected",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [],
        selectedKnowledgeLevel: const [KnowledgeLevel.practicing],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("Knowledge level 'Seen' selected", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [],
        selectedKnowledgeLevel: const [KnowledgeLevel.seen],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isFalse);
    });

    testWidgets("Knowledge level 'Never seen' selected",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [],
        selectedKnowledgeLevel: const [KnowledgeLevel.neverSeen],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isTrue);
    });

    testWidgets("Multiple selections", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {},
        selectedJlptLevel: const [JLPTLevel.level1, JLPTLevel.level4],
        selectedKnowledgeLevel: const [
          KnowledgeLevel.neverSeen,
          KnowledgeLevel.practicing
        ],
      ));
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(9));

      expect((tester.widget(checkboxes.at(0)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(1)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(2)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(3)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(4)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(5)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(6)) as Checkbox).value, isTrue);
      expect((tester.widget(checkboxes.at(7)) as Checkbox).value, isFalse);
      expect((tester.widget(checkboxes.at(8)) as Checkbox).value, isTrue);
    });

    testWidgets("Click on close", (WidgetTester tester) async {
      var isClicked = false;
      await tester.pumpLocalizedWidget(FilterBy(
        filterGlossary: () => {isClicked = true},
        selectedJlptLevel: const [JLPTLevel.level1, JLPTLevel.level4],
        selectedKnowledgeLevel: const [
          KnowledgeLevel.neverSeen,
          KnowledgeLevel.practicing
        ],
      ));
      await tester.pumpAndSettle();

      final buttons = find.byType(IconButton);
      expect(buttons, findsOneWidget);
      expect(isClicked, isFalse);

      await tester.tap(buttons.first);
      expect(isClicked, isTrue);
    });
  });
}
