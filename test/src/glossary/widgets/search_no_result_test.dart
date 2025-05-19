import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/glossary/widgets/search_no_result.dart";

import "../../../helpers.dart";

void main() {
  group("SearchNoResult", () {
    testWidgets("Should display correct title for kanji resource type", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        const SearchNoResult(type: ResourceType.kanji),
      );
      await tester.pumpAndSettle();

      final l10n = await setupLocalizations();

      // Verify the title is displayed with the correct resource type
      expect(
        find.text(l10n.glossary_not_found(ResourceType.kanji.name)),
        findsOneWidget,
      );

      // Verify the subtitle is displayed
      expect(find.text(l10n.glossary_not_found_subtitle), findsOneWidget);
    });

    testWidgets("Should display correct title for vocabulary resource type", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        const SearchNoResult(type: ResourceType.vocabulary),
      );
      await tester.pumpAndSettle();

      final l10n = await setupLocalizations();

      // Verify the title is displayed with the correct resource type
      expect(
        find.text(l10n.glossary_not_found(ResourceType.vocabulary.name)),
        findsOneWidget,
      );

      // Verify the subtitle is displayed
      expect(find.text(l10n.glossary_not_found_subtitle), findsOneWidget);
    });

    testWidgets("Should display correct title for kana resource type", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        const SearchNoResult(type: ResourceType.kana),
      );
      await tester.pumpAndSettle();

      final l10n = await setupLocalizations();

      // Verify the title is displayed with the correct resource type
      expect(
        find.text(l10n.glossary_not_found(ResourceType.kana.name)),
        findsOneWidget,
      );

      // Verify the subtitle is displayed
      expect(find.text(l10n.glossary_not_found_subtitle), findsOneWidget);
    });

    testWidgets("Should use correct text styles", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(
        const SearchNoResult(type: ResourceType.kanji),
      );
      await tester.pumpAndSettle();

      final l10n = await setupLocalizations();

      // Get the theme from the widget
      final theme = Theme.of(tester.element(find.byType(SearchNoResult)));

      // Verify the title uses titleLarge style
      final titleWidget = tester.widget<Text>(
        find.text(l10n.glossary_not_found(ResourceType.kanji.name)),
      );
      expect(titleWidget.style, equals(theme.textTheme.titleLarge));

      // Verify the subtitle uses bodyMedium style
      final subtitleWidget = tester.widget<Text>(
        find.text(l10n.glossary_not_found_subtitle),
      );
      expect(subtitleWidget.style, equals(theme.textTheme.bodyMedium));
    });
  });
}
