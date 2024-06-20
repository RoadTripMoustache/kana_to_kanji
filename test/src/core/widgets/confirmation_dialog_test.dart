import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/confirmation_dialog.dart";
import "package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view.dart";

import "../../../helpers.dart";

void main() {
  group("ConfirmationDialog", () {
    testWidgets("UI", (WidgetTester tester) async {
      const title = "toto titre";
      const content = "toto content";
      const cancelLabel = "toto cancelLabel";
      const validationLabel = "toto validationLabel";
      final confirmationDialog = ConfirmationDialog(
          title: title,
          content: content,
          cancelButtonLabel: cancelLabel,
          validationButtonLabel: validationLabel,
          cancel: () => {},
          validate: () => {});
      await tester.pumpLocalizedRouterWidget(confirmationDialog,
          initialLocation: PrepareQuizView.routeName);
      await tester.pumpAndSettle();

      final widget = find.byType(ConfirmationDialog);

      expect(widget, findsOneWidget);
      expect(find.text(title), findsOneWidget,
          reason: "Should contain the title");

      expect(widget, findsOneWidget);
      expect(find.text(content), findsOneWidget,
          reason: "Should contain the content");

      expect(widget, findsOneWidget);
      expect(find.text(cancelLabel), findsOneWidget,
          reason: "Should contain the cancelLabel");

      expect(widget, findsOneWidget);
      expect(find.text(validationLabel), findsOneWidget,
          reason: "Should contain the validationLabel");
    });

    group("Behaviours", () {
      testWidgets("Click on cancel", (WidgetTester tester) async {
        const title = "toto titre";
        const content = "toto content";
        const cancelLabel = "toto cancelLabel";
        const validationLabel = "toto validationLabel";
        bool isCancelled = false;
        bool isValidated = false;
        final confirmationDialog = ConfirmationDialog(
            title: title,
            content: content,
            cancelButtonLabel: cancelLabel,
            validationButtonLabel: validationLabel,
            cancel: () => {isCancelled = true},
            validate: () => {isValidated = true});
        await tester.pumpLocalizedRouterWidget(confirmationDialog,
            initialLocation: PrepareQuizView.routeName);
        await tester.pumpAndSettle();

        await tester.tap(find.text(cancelLabel));
        await tester.pumpAndSettle();

        expect(isCancelled, true);
        expect(isValidated, false);
      });

      testWidgets("Click on validation", (WidgetTester tester) async {
        const title = "toto titre";
        const content = "toto content";
        const cancelLabel = "toto cancelLabel";
        const validationLabel = "toto validationLabel";
        bool isCancelled = false;
        bool isValidated = false;
        final confirmationDialog = ConfirmationDialog(
            title: title,
            content: content,
            cancelButtonLabel: cancelLabel,
            validationButtonLabel: validationLabel,
            cancel: () => {isCancelled = true},
            validate: () => {isValidated = true});
        await tester.pumpLocalizedRouterWidget(confirmationDialog,
            initialLocation: PrepareQuizView.routeName);
        await tester.pumpAndSettle();

        await tester.tap(find.text(validationLabel));
        await tester.pumpAndSettle();

        expect(isCancelled, false);
        expect(isValidated, true);
      });
    });
  });
}
