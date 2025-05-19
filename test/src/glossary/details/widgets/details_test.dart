import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart";

import "../../../../helpers.dart";

void main() {
  group("Details", () {
    late ScrollController scrollController;
    int onSpeakerPressedCallCount = 0;
    String? lastPressedReading;

    Future<void> mockOnSpeakerPressed(String reading) async {
      onSpeakerPressedCallCount++;
      lastPressedReading = reading;
    }

    setUp(() {
      scrollController = ScrollController();
      onSpeakerPressedCallCount = 0;
      lastPressedReading = null;
    });

    tearDown(() {
      scrollController.dispose();
    });

    // Create dummy pronunciation details
    final pronunciationDetails1 = PronunciationDetails(
      reading: "ほん",
      meanings: ["book", "main"],
      exampleUids: [ResourceUid.fromJson("example-1")],
      examples: [
        Example(
          uid: ResourceUid.fromJson("example-1"),
          sentence: "本を読む",
          kanji: ["本", "を", "読む"],
          reading: ["ほん", "を", "よむ"],
          translation: "to read a book",
        ),
      ],
    );

    final pronunciationDetails2 = PronunciationDetails(
      reading: "もと",
      meanings: ["origin", "source"],
      examples: [],
    );

    final allPronunciations = [pronunciationDetails1, pronunciationDetails2];

    testWidgets("Should display section title", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(
        Details(
          scrollController: scrollController,
          pronunciations: allPronunciations,
          toBold: "本",
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await setupLocalizations();

      // Verify section title is displayed
      expect(
        find.text(l10n.glossary_details_readings_and_meanings(2, 4)),
        findsOneWidget,
      );
    });

    testWidgets("Should display correct number of pronunciation cards", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        Details(
          scrollController: scrollController,
          pronunciations: allPronunciations,
          toBold: "本",
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Verify correct number of pronunciation cards are displayed
      expect(find.byType(PronunciationCard), findsNWidgets(2));

      // Verify pronunciations are displayed
      expect(find.text("ほん"), findsOneWidget);
      expect(find.text("もと"), findsOneWidget);
    });

    testWidgets("Should call onSpeakerPressed when speaker button is pressed", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        Details(
          scrollController: scrollController,
          pronunciations: allPronunciations,
          toBold: "本",
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the first speaker button
      await tester.tap(find.byIcon(Icons.volume_up_rounded).first);
      await tester.pumpAndSettle();

      // Verify onSpeakerPressed was called with the correct reading
      expect(onSpeakerPressedCallCount, 1);
      expect(lastPressedReading, equals("ほん"));

      // Reset
      onSpeakerPressedCallCount = 0;
      lastPressedReading = null;

      // Find and tap the second speaker button
      await tester.tap(find.byIcon(Icons.volume_up_rounded).last);
      await tester.pumpAndSettle();

      // Verify onSpeakerPressed was called with the correct reading
      expect(onSpeakerPressedCallCount, 1);
      expect(lastPressedReading, equals("もと"));
    });

    testWidgets("Should calculate correct width for longest pronunciation", (
      WidgetTester tester,
    ) async {
      // Create pronunciations with different lengths
      final shortPronunciation = PronunciationDetails(
        reading: "あ",
        meanings: ["a"],
      );

      final longPronunciation = PronunciationDetails(
        reading: "あいうえお",
        meanings: ["aiueo"],
      );

      await tester.pumpLocalizedWidget(
        Details(
          scrollController: scrollController,
          pronunciations: [shortPronunciation, longPronunciation],
          toBold: "あ",
          onSpeakerPressed: mockOnSpeakerPressed,
        ),
      );
      await tester.pumpAndSettle();

      // Find all PronunciationTitle widgets
      final pronunciationCards = tester.widgetList<PronunciationCard>(
        find.byType(PronunciationCard),
      );

      // Verify all cards have the same pronunciationMinWidth
      final firstCardWidth = pronunciationCards.first.pronunciationMinWidth;
      for (final card in pronunciationCards) {
        expect(card.pronunciationMinWidth, equals(firstCardWidth));
      }

      // Verify the width is based on the longest pronunciation
      expect(firstCardWidth, greaterThan(48.0)); // Minimum width is 48.0
    });
  });
}
