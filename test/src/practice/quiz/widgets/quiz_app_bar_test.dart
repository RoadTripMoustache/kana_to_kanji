import "package:flutter_rtm/flutter_rtm.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/rounded_linear_progress_indicator.dart";
import "package:kana_to_kanji/src/practice/quiz/widgets/quiz_app_bar.dart";

import "../../../../helpers.dart";

bool onClosePressedCalled = false;
bool onSkipPressedCalled = false;

void onClosePressed() {
  onClosePressedCalled = true;
}

Future<void> onSkipPressed() async {
  onSkipPressedCalled = true;
}

void main() {
  group("QuizAppBar", () {
    const progressBarValue = 22.6;
    testWidgets("UI", (WidgetTester tester) async {
      onClosePressedCalled = false;
      onSkipPressedCalled = false;

      const widget = QuizAppBar(
        progressBarValue: progressBarValue,
        onClosePressed: onClosePressed,
        onSkipPressed: onSkipPressed,
      );

      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(RoundedLinearProgressIndicator), findsOneWidget);
      expect(find.byType(RTMIconButton), findsNWidgets(1));
      expect(find.byType(RTMTextButton), findsNWidgets(1));
      expect(onClosePressedCalled, false);
      expect(onSkipPressedCalled, false);
    });

    testWidgets("It should call onClosePressed when close icon is pressed", (
      WidgetTester tester,
    ) async {
      onClosePressedCalled = false;
      onSkipPressedCalled = false;

      const widget = QuizAppBar(
        progressBarValue: progressBarValue,
        onClosePressed: onClosePressed,
        onSkipPressed: onSkipPressed,
      );

      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      final closeButtonWidget = find.byType(RTMIconButton);
      await tester.tap(closeButtonWidget.first);

      expect(onClosePressedCalled, true);
      expect(onSkipPressedCalled, false);
    });

    testWidgets("It should call onSkipPressed when skip button is pressed", (
      WidgetTester tester,
    ) async {
      onClosePressedCalled = false;
      onSkipPressedCalled = false;

      const widget = QuizAppBar(
        progressBarValue: progressBarValue,
        onClosePressed: onClosePressed,
        onSkipPressed: onSkipPressed,
      );

      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      final skipButtonWidget = find.byType(RTMTextButton);
      await tester.tap(skipButtonWidget.first);

      expect(onClosePressedCalled, false);
      expect(onSkipPressedCalled, true);
    });
  });
}
