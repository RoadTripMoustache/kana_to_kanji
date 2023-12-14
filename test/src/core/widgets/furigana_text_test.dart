import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/widgets/furigana_text.dart';

import '../../../helpers.dart';

void main() {
  group("FuriganaText", () {
    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(FuriganaText);
    }

    group("Furigana", () {
      const text = "本";
      const furigana = "ほん";

      testWidgets("Should show furigana if provided and showFurigana true",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            const FuriganaText(
                text: text, furigana: furigana, showFurigana: true));

        expect(widget, findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(text)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(furigana)),
            findsOneWidget,
            reason: "Furigana should be showed");
      });

      testWidgets("Should not show furigana if showFurigana false",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            const FuriganaText(
                text: text, furigana: furigana, showFurigana: false));

        expect(widget, findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byType(Column)),
            findsNothing,
            reason: "Only present when furigana is showed");
        expect(find.descendant(of: widget, matching: find.text(text)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(furigana)),
            findsNothing,
            reason: "Furigana should not be showed");
      });

      testWidgets("Should not show furigana if not provided",
          (WidgetTester tester) async {
        final widget = await pump(
            tester, const FuriganaText(text: text, showFurigana: true));

        expect(widget, findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byType(Column)),
            findsNothing,
            reason: "Only present when furigana is showed");
        expect(find.descendant(of: widget, matching: find.text(text)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(furigana)),
            findsNothing,
            reason: "Furigana should not be showed");
      });

      testWidgets("Furigana default size should be 12",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            const FuriganaText(
                text: text, furigana: furigana, showFurigana: true));

        final furiganaTextFound =
            find.descendant(of: widget, matching: find.text(furigana));
        final furiganaTextWidget =
            tester.firstWidget(furiganaTextFound) as Text;

        expect(furiganaTextFound, findsOneWidget);
        expect(furiganaTextWidget.style!.fontSize, 12);
      });
    });
  });
}
