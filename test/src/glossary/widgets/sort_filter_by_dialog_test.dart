import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/glossary/widgets/sort_filter_by_dialog.dart";

import "../../../helpers.dart";

void main() {
  group("SortFilterByDialog", () {
    late List<JLPTLevel> submittedJlptLevels;
    late List<KnowledgeLevel> submittedKnowledgeLevels;
    late SortOrder submittedSortOrder;
    int onSubmitCallCount = 0;

    void mockOnSubmit(
      List<JLPTLevel> jlptLevels,
      List<KnowledgeLevel> knowledgeLevels,
      SortOrder sortOrder,
    ) {
      submittedJlptLevels = jlptLevels;
      submittedKnowledgeLevels = knowledgeLevels;
      submittedSortOrder = sortOrder;
      onSubmitCallCount++;
    }

    setUp(() {
      submittedJlptLevels = [];
      submittedKnowledgeLevels = [];
      submittedSortOrder = SortOrder.alphabetical;
      onSubmitCallCount = 0;
    });

    Future<void> pumpDialog(
      WidgetTester tester, {
      List<JLPTLevel> selectedJlptLevel = const [],
      List<KnowledgeLevel> selectedKnowledgeLevel = const [],
      SortOrder sortOrder = SortOrder.alphabetical,
    }) async {
      await tester.pumpLocalizedRouterWidget(
        SortFilterByDialog(
          onSubmit: mockOnSubmit,
          selectedJlptLevel: selectedJlptLevel,
          selectedKnowledgeLevel: selectedKnowledgeLevel,
          sortOrder: sortOrder,
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("Should display initial state correctly", (
      WidgetTester tester,
    ) async {
      final initialJlptLevels = [JLPTLevel.n5, JLPTLevel.n4];
      final initialKnowledgeLevels = [KnowledgeLevel.learned];
      const initialSortOrder = SortOrder.japanese;

      await pumpDialog(
        tester,
        selectedJlptLevel: initialJlptLevels,
        selectedKnowledgeLevel: initialKnowledgeLevels,
        sortOrder: initialSortOrder,
      );

      final l10n = await setupLocalizations();

      // Verify JLPT level chips are selected correctly
      for (final level in JLPTLevel.values) {
        final chip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, l10n.jlpt_level_short(level.value)),
        );
        expect(chip.selected, equals(initialJlptLevels.contains(level)));
      }

      // Verify knowledge level chips are selected correctly
      for (final level in KnowledgeLevel.values) {
        final chip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, l10n.knowledge_level(level.name)),
        );
        expect(chip.selected, equals(initialKnowledgeLevels.contains(level)));
      }

      // Verify sort order is selected correctly
      final segmentedButton = tester.widget<SegmentedButton<SortOrder>>(
        find.byType(SegmentedButton<SortOrder>),
      );
      expect(segmentedButton.selected, equals({initialSortOrder}));
    });

    testWidgets("Should toggle JLPT level when chip is tapped", (
      WidgetTester tester,
    ) async {
      await pumpDialog(tester);
      final l10n = await setupLocalizations();

      // Tap the N5 chip
      await tester.tap(
        find.widgetWithText(
          FilterChip,
          l10n.jlpt_level_short(JLPTLevel.n5.value),
        ),
      );
      await tester.pumpAndSettle();

      // Verify N5 chip is selected
      final n5Chip = tester.widget<FilterChip>(
        find.widgetWithText(
          FilterChip,
          l10n.jlpt_level_short(JLPTLevel.n5.value),
        ),
      );
      expect(n5Chip.selected, isTrue);

      // Tap the N5 chip again to deselect
      await tester.tap(
        find.widgetWithText(
          FilterChip,
          l10n.jlpt_level_short(JLPTLevel.n5.value),
        ),
      );
      await tester.pumpAndSettle();

      // Verify N5 chip is deselected
      final n5ChipAfter = tester.widget<FilterChip>(
        find.widgetWithText(
          FilterChip,
          l10n.jlpt_level_short(JLPTLevel.n5.value),
        ),
      );
      expect(n5ChipAfter.selected, isFalse);
    });

    testWidgets("Should toggle knowledge level when chip is tapped", (
      WidgetTester tester,
    ) async {
      await pumpDialog(tester);
      final l10n = await setupLocalizations();

      // Tap the Known chip
      await tester.tap(
        find.widgetWithText(
          FilterChip,
          l10n.knowledge_level(KnowledgeLevel.learned.name),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Known chip is selected
      final knownChip = tester.widget<FilterChip>(
        find.widgetWithText(
          FilterChip,
          l10n.knowledge_level(KnowledgeLevel.learned.name),
        ),
      );
      expect(knownChip.selected, isTrue);

      // Tap the Known chip again to deselect
      await tester.tap(
        find.widgetWithText(
          FilterChip,
          l10n.knowledge_level(KnowledgeLevel.learned.name),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Known chip is deselected
      final knownChipAfter = tester.widget<FilterChip>(
        find.widgetWithText(
          FilterChip,
          l10n.knowledge_level(KnowledgeLevel.learned.name),
        ),
      );
      expect(knownChipAfter.selected, isFalse);
    });

    testWidgets("Should change sort order when segment is tapped", (
      WidgetTester tester,
    ) async {
      await pumpDialog(tester);
      final l10n = await setupLocalizations();

      // Tap the Japanese sort order segment
      await tester.tap(find.text(l10n.glossary_sort_by_japanese));
      await tester.pumpAndSettle();

      // Verify Japanese sort order is selected
      final segmentedButton = tester.widget<SegmentedButton<SortOrder>>(
        find.byType(SegmentedButton<SortOrder>),
      );
      expect(segmentedButton.selected, equals({SortOrder.japanese}));
    });

    testWidgets(
      "Should call onSubmit with selected filters when Apply is tapped",
      (WidgetTester tester) async {
        await pumpDialog(tester);
        final l10n = await setupLocalizations();

        // Select N5 JLPT level
        await tester.tap(find.text(l10n.jlpt_level_short(JLPTLevel.n5.value)));
        await tester.pumpAndSettle();

        // Select Known knowledge level
        await tester.tap(
          find.widgetWithText(
            FilterChip,
            l10n.knowledge_level(KnowledgeLevel.learned.name),
          ),
        );
        await tester.pumpAndSettle();

        // Change sort order to Japanese
        await tester.tap(find.text(l10n.glossary_sort_by_japanese));
        await tester.pumpAndSettle();

        // Tap the Apply button
        await tester.tap(find.text(l10n.glossary_filter_by_apply));
        await tester.pumpAndSettle();

        // Verify onSubmit was called with the correct parameters
        expect(onSubmitCallCount, 1);
        expect(submittedJlptLevels, equals([JLPTLevel.n5]));
        expect(submittedKnowledgeLevels, equals([KnowledgeLevel.learned]));
        expect(submittedSortOrder, equals(SortOrder.japanese));
      },
    );

    testWidgets(
      "Should clear selections and call onSubmit when Clear is tapped",
      (WidgetTester tester) async {
        final initialJlptLevels = [JLPTLevel.n5, JLPTLevel.n4];
        final initialKnowledgeLevels = [KnowledgeLevel.learned];
        const initialSortOrder = SortOrder.japanese;

        await pumpDialog(
          tester,
          selectedJlptLevel: initialJlptLevels,
          selectedKnowledgeLevel: initialKnowledgeLevels,
          sortOrder: initialSortOrder,
        );
        final l10n = await setupLocalizations();

        // Tap the Clear button
        await tester.tap(find.text(l10n.glossary_filter_by_clear));
        await tester.pumpAndSettle();

        // Verify onSubmit was called with empty selections and original
        // sort order
        expect(onSubmitCallCount, 1);
        expect(submittedJlptLevels, isEmpty);
        expect(submittedKnowledgeLevels, isEmpty);
        expect(submittedSortOrder, equals(initialSortOrder));
      },
    );
  });
}
