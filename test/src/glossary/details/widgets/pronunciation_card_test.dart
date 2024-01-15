import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart';

import '../../../../helpers.dart';

void main() {
  group("PronunciationCard", () {
    const sampleHiraganaPronunciation = "あ";

    group("UI", () {
      testWidgets(
          "Should contains an ActionChip with volume up icon and pronunciation passed",
          (WidgetTester tester) async {
        await tester.pumpLocalizedWidget(const PronunciationCard(
            pronunciation: sampleHiraganaPronunciation));
        await tester.pumpAndSettle();

        final widget = find.byType(PronunciationCard);

        expect(widget, findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byType(ActionChip)), findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byIcon(Icons.volume_up_rounded)), findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(sampleHiraganaPronunciation)), findsOneWidget);
      });
    });
  });
}
