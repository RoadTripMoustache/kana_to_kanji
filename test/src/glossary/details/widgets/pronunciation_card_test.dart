import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/example_line.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_title.dart";

import "../../../../helpers.dart";

void main() {
  group("PronunciationCard", () {
    int onSpeakerPressedCallCount = 0;
    String? lastPressedReading;

    Future<void> mockOnSpeakerPressed(String reading) async {
      onSpeakerPressedCallCount++;
      lastPressedReading = reading;
    }

    setUp(() {
      onSpeakerPressedCallCount = 0;
      lastPressedReading = null;
    });

    testWidgets("Should display pronunciation and meanings", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const meanings = ["book", "main"];

      await tester.pumpLocalizedWidget(
        PronunciationCard(
          pronunciation: pronunciation,
          toBold: "本",
          meanings: meanings,
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Verify pronunciation is displayed
      expect(find.text(pronunciation), findsOneWidget);

      // Verify meanings are displayed
      for (final meaning in meanings) {
        expect(
          find.textContaining(meaning, findRichText: true),
          findsOneWidget,
        );
      }
    });

    testWidgets("Should display examples when provided", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const meanings = ["book"];
      final examples = [
        Example(
          uid: ResourceUid.fromJson("example-1"),
          sentence: "これは本です。",
          translation: "This is a book.",
          kanji: ["これ", "は", "本", "です。"],
          reading: ["kore", "wa", "hon", "desu"],
        ),
      ];

      await tester.pumpLocalizedWidget(
        PronunciationCard(
          pronunciation: pronunciation,
          toBold: "本",
          meanings: meanings,
          examples: examples,
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Verify example is displayed
      expect(find.byType(ExampleLine), findsOneWidget);
      expect(find.text("これは本です。", findRichText: true), findsOneWidget);
      expect(find.text("This is a book."), findsOneWidget);
    });

    testWidgets("Should not display examples when not provided", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const meanings = ["book"];

      await tester.pumpLocalizedWidget(
        PronunciationCard(
          pronunciation: pronunciation,
          toBold: "本",
          meanings: meanings,
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Verify no example is displayed
      expect(find.byType(ExampleLine), findsNothing);
    });

    testWidgets("Should call onSpeakerPressed when speaker button is pressed", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const meanings = ["book"];

      await tester.pumpLocalizedWidget(
        PronunciationCard(
          pronunciation: pronunciation,
          toBold: "本",
          meanings: meanings,
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the speaker button
      await tester.tap(find.byIcon(Icons.volume_up_rounded));
      await tester.pumpAndSettle();

      // Verify onSpeakerPressed was called with the correct pronunciation
      expect(onSpeakerPressedCallCount, 1);
      expect(lastPressedReading, equals(pronunciation));
    });

    testWidgets("Should use provided pronunciationMinWidth", (
      WidgetTester tester,
    ) async {
      const pronunciation = "ほん";
      const meanings = ["book"];
      const minWidth = 100.0;

      await tester.pumpLocalizedWidget(
        PronunciationCard(
          pronunciation: pronunciation,
          toBold: "本",
          meanings: meanings,
          pronunciationMinWidth: minWidth,
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Find the PronunciationTitle widget
      final pronunciationTitle = tester.widget<PronunciationTitle>(
        find.byType(PronunciationTitle),
      );

      // Verify it has the correct minWidth
      expect(pronunciationTitle.minWidth, equals(minWidth));
    });
  });
}
