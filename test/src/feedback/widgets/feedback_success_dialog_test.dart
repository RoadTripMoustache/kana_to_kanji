import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_success_dialog.dart';

import '../../../helpers.dart';

void main() {
  group("FeedbackSuccessDialog", () {
    late final AppLocalizations l10n;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    testWidgets("Should have a done green icon and thanks text",
        (WidgetTester tester) async {
      await tester
          .pumpWidget(const LocalizedWidget(child: FeedbackSuccessDialog()));
      await tester.pumpAndSettle();

      final widget = find.byType(FeedbackSuccessDialog);
      expect(widget, findsOneWidget);
      expect(
          find.descendant(
              of: widget,
              matching: find.byWidgetPredicate((widget) {
                if (widget is Icon) {
                  return widget.icon == Icons.done_rounded &&
                      widget.color == Colors.green &&
                      widget.size == 52;
                }

                return false;
              })),
          findsOneWidget,
          reason: "Should have a Done Rounded green icon of size 52");
      expect(
          find.descendant(
              of: widget, matching: find.text(l10n.feedback_thanks)),
          findsOneWidget,
          reason: "Should have the Thanks text");
    });
  });
}
