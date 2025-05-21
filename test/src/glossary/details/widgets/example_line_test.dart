import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/example_line.dart";

import "../../../../helpers.dart";

void main() {
  group("ExampleLine", () {
    final example = Example(
      uid: ResourceUid.fromJson("example-1"),
      sentence: "これは本です。",
      translation: "This is a book.",
      kanji: ["これ", "は", "本", "です。"],
      reading: ["kore", "wa", "hon", "desu"],
    );

    testWidgets("Should display example sentence and translation", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        ExampleLine(example: example, toBold: "本"),
      );
      await tester.pumpAndSettle();

      // Verify sentence is displayed
      expect(find.text(example.sentence, findRichText: true), findsOneWidget);

      // Verify translation is displayed
      expect(find.text(example.translation), findsOneWidget);
    });

    testWidgets("Should display toBold string in bold", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        ExampleLine(example: example, toBold: "本"),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.firstWidget<RichText>(
        find.text(example.sentence, findRichText: true),
      );

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Verify there are multiple children (the split parts and the bold part)
      expect(textSpan.children!.length, greaterThan(1));

      // Find the bold TextSpan
      final boldSpan =
          textSpan.children!.firstWhere(
                (span) => (span as TextSpan).text == "本",
                orElse: () => const TextSpan(text: ""),
              )
              as TextSpan;

      // Verify the bold span has bold style
      expect(boldSpan.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets("Should handle multiple occurrences of toBold", (
      WidgetTester tester,
    ) async {
      final example2 = example.copyWith(
        sentence: "本は本棚に置いてあります。",
        translation: "The book is on the bookshelf.",
        kanji: ["本", "は", "本棚", "に", "置いて", "あります。"],
        reading: ["hon", "wa", "hondana", "ni", "oite", "arimasu"],
      );

      await tester.pumpLocalizedWidget(
        ExampleLine(example: example2, toBold: "本"),
      );
      await tester.pumpAndSettle();

      // Find the RichText widget
      final richText = tester.firstWidget<RichText>(
        find.text(example2.sentence, findRichText: true),
      );

      // Get the TextSpan
      final textSpan = richText.text as TextSpan;

      // Count the number of bold spans
      int boldSpanCount = 0;
      for (final span in textSpan.children!) {
        final textSpan = span as TextSpan;
        if (textSpan.text == "本" &&
            textSpan.style?.fontWeight == FontWeight.bold) {
          boldSpanCount++;
        }
      }

      // Verify there are multiple bold spans (one for each occurrence of "本")
      expect(boldSpanCount, greaterThan(1));
    });

    testWidgets("Should handle toBold not in sentence", (
      WidgetTester tester,
    ) async {
      final example = Example(
        uid: ResourceUid.fromJson("example-1"),
        sentence: "これはペンです。",
        translation: "This is a pen.",
        kanji: ["これ", "は", "ペン", "です"],
        reading: ["kore", "wa", "pen", "desu"],
      );

      await tester.pumpLocalizedWidget(
        ExampleLine(example: example, toBold: "本"),
      );
      await tester.pumpAndSettle();

      // Verify sentence is displayed as is
      expect(find.text("これはペンです。", findRichText: true), findsOneWidget);

      // Verify no bold spans for "本"
      final richText = tester.firstWidget<RichText>(find.byType(RichText));
      final textSpan = richText.text as TextSpan;

      bool hasBoldSpan = false;
      for (final span in textSpan.children ?? []) {
        final textSpan = span as TextSpan;
        if (textSpan.text == "本" &&
            textSpan.style?.fontWeight == FontWeight.bold) {
          hasBoldSpan = true;
          break;
        }
      }

      expect(hasBoldSpan, isFalse);
    });
  });
}
