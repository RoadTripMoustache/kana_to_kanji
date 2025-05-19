import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_title.dart"
    as pt;

import "../../../../helpers.dart";

void main() {
  group("PronunciationTitle", () {
    testWidgets("Should have correct minimum width", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const minWidth = 100.0;

      await tester.pumpLocalizedWidget(
        const pt.PronunciationTitle(
          pronunciation: pronunciation,
          minWidth: minWidth,
        ),
      );
      await tester.pumpAndSettle();

      // Find the Container widget
      final container = tester.widget<Container>(find.byType(Container));

      // Verify the container has the correct minimum width constraint
      final constraints = container.constraints!;
      expect(constraints.minWidth, equals(minWidth + 16)); // minWidth + padding
    });

    testWidgets("Should have correct background color", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";

      await tester.pumpLocalizedWidget(
        const pt.PronunciationTitle(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Find the Container widget
      final container = tester.widget<Container>(find.byType(Container));

      // Get the theme from the widget
      final theme = Theme.of(
        tester.element(find.byType(pt.PronunciationTitle)),
      );

      // Verify the container has the correct background color
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, equals(theme.bottomSheetTheme.backgroundColor));
    });
  });

  group("pt.Title", () {
    testWidgets("Should display simple pronunciation in bold", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";

      await tester.pumpLocalizedWidget(
        const pt.Title(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Verify the pronunciation is displayed
      expect(find.text(pronunciation), findsOneWidget);

      // Verify the text is bold
      final text = tester.widget<Text>(find.text(pronunciation));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets("Should handle pronunciation with leading hyphen", (
      WidgetTester tester,
    ) async {
      const pronunciation = "-ほん";

      await tester.pumpLocalizedWidget(
        const pt.Title(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.widget<RichText>(find.byType(RichText));

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Verify there are two children (the hyphen and the pronunciation)
      expect(textSpan.children!.length, equals(2));

      // Verify the first child is the hyphen with normal weight
      final hyphenSpan = textSpan.children![0] as TextSpan;
      expect(hyphenSpan.text, equals("-"));
      expect(hyphenSpan.style?.fontWeight, equals(FontWeight.normal));

      // Verify the second child is the pronunciation with bold weight
      final pronunciationSpan = textSpan.children![1] as TextSpan;
      expect(pronunciationSpan.text, equals("ほん"));
      expect(pronunciationSpan.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets("Should handle pronunciation with trailing hyphen", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん-";

      await tester.pumpLocalizedWidget(
        const pt.Title(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.widget<RichText>(find.byType(RichText));

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Verify there are two children (the pronunciation and the hyphen)
      expect(textSpan.children!.length, equals(2));

      // Verify the first child is the pronunciation with bold weight
      final pronunciationSpan = textSpan.children![0] as TextSpan;
      expect(pronunciationSpan.text, equals("ほん"));
      expect(pronunciationSpan.style?.fontWeight, equals(FontWeight.bold));

      // Verify the second child is the hyphen with normal weight
      final hyphenSpan = textSpan.children![1] as TextSpan;
      expect(hyphenSpan.text, equals("-"));
      expect(hyphenSpan.style?.fontWeight, equals(FontWeight.normal));
    });

    testWidgets("Should handle pronunciation with dot", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん.き";

      await tester.pumpLocalizedWidget(
        const pt.Title(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.widget<RichText>(find.byType(RichText));

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Verify there are two children
      // (the part before the dot and the part with the dot)
      expect(textSpan.children!.length, equals(2));

      // Verify the first child is the part before the dot with bold weight
      final beforeDotSpan = textSpan.children![0] as TextSpan;
      expect(beforeDotSpan.text, equals("ほん"));
      expect(beforeDotSpan.style?.fontWeight, equals(FontWeight.bold));

      // Verify the second child is the part with the dot with normal weight
      final withDotSpan = textSpan.children![1] as TextSpan;
      expect(withDotSpan.text, equals(".き"));
      expect(withDotSpan.style?.fontWeight, equals(FontWeight.normal));
    });

    testWidgets("Should handle pronunciation with both hyphen and dot", (
      WidgetTester tester,
    ) async {
      const pronunciation = "-ほん.き-";

      await tester.pumpLocalizedWidget(
        const pt.Title(pronunciation: pronunciation),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.widget<RichText>(find.byType(RichText));

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Verify there are four children
      // (leading hyphen, part before dot, part with dot, trailing hyphen)
      expect(textSpan.children!.length, equals(4));

      // Verify the first child is the leading hyphen with normal weight
      final leadingHyphenSpan = textSpan.children![0] as TextSpan;
      expect(leadingHyphenSpan.text, equals("-"));
      expect(leadingHyphenSpan.style?.fontWeight, equals(FontWeight.normal));

      // Verify the second child is the part before the dot with bold weight
      final beforeDotSpan = textSpan.children![1] as TextSpan;
      expect(beforeDotSpan.text, equals("ほん"));
      expect(beforeDotSpan.style?.fontWeight, equals(FontWeight.bold));

      // Verify the third child is the part with the dot with normal weight
      final withDotSpan = textSpan.children![2] as TextSpan;
      expect(withDotSpan.text, equals(".き"));
      expect(withDotSpan.style?.fontWeight, equals(FontWeight.normal));

      // Verify the fourth child is the trailing hyphen with normal weight
      final trailingHyphenSpan = textSpan.children![3] as TextSpan;
      expect(trailingHyphenSpan.text, equals("-"));
      expect(trailingHyphenSpan.style?.fontWeight, equals(FontWeight.normal));
    });
  });
}
