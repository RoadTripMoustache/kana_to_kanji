import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/stat_card.dart";

import "../../../helpers.dart";

class StatTimerData {
  final Duration duration;
  final String testCase;
  final String expectedDurationText;

  const StatTimerData(this.duration, this.testCase, this.expectedDurationText);
}

Future<void> main() async {
  Future<Finder> pump(WidgetTester tester, Widget widget) async {
    await tester.pumpLocalizedWidget(widget);
    await tester.pumpAndSettle();

    return find.byType(StatCard);
  }

  late final AppLocalizations l10n;

  setUpAll(() async {
    l10n = await setupLocalizations();
  });

  group("StatCard", () {
    const icon = Icon(Icons.access_alarm);
    const title = "totoTitle";
    const subtitle = "totoSubtitle";
    const color = Colors.blue;
    const titleTextStyle = TextStyle(color: Colors.orange);
    const subtitleTextStyle = TextStyle(color: Colors.green);

    group("small", () {
      testWidgets("without background color", (WidgetTester tester) async {
        final widget =
            await pump(tester, StatCard.small(icon: icon, title: title));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsNothing);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
      testWidgets("with background color", (WidgetTester tester) async {
        final widget = await pump(
            tester,
            StatCard.small(
              icon: icon,
              title: title,
              backgroundColor: color,
            ));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, color);
        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsNothing);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
      testWidgets("with title text style", (WidgetTester tester) async {
        final widget = await pump(
            tester,
            StatCard.small(
              icon: icon,
              title: title,
              titleTextStyle: titleTextStyle,
            ));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);

        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);
        final Text titleWidget = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Text)));
        expect(titleWidget.style, titleTextStyle);

        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsNothing);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
    });

    group("large", () {
      testWidgets("without background color", (WidgetTester tester) async {
        final widget = await pump(tester,
            StatCard.large(icon: icon, title: title, subtitle: subtitle));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsOneWidget);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.max);
      });
      testWidgets("with background color", (WidgetTester tester) async {
        final widget = await pump(
            tester,
            StatCard.large(
              icon: icon,
              title: title,
              subtitle: subtitle,
              backgroundColor: color,
            ));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, color);
        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsOneWidget);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.max);
      });
      testWidgets("with title text style", (WidgetTester tester) async {
        final widget = await pump(
            tester,
            StatCard.large(
              icon: icon,
              title: title,
              subtitle: subtitle,
              titleTextStyle: titleTextStyle,
              subtitleTextStyle: subtitleTextStyle,
            ));

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);

        expect(find.descendant(of: widget, matching: find.text(title)),
            findsOneWidget);

        expect(find.descendant(of: widget, matching: find.byWidget(icon)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text(subtitle)),
            findsOneWidget);
        final titleWidgets = tester.widgetList(
            find.descendant(of: widget, matching: find.byType(Text)));
        expect((titleWidgets.elementAt(0) as Text).style, titleTextStyle);
        expect((titleWidgets.elementAt(1) as Text).style, subtitleTextStyle);

        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.max);
      });
    });

    group("streak", () {
      testWidgets("small", (WidgetTester tester) async {
        final widget = await pump(
          tester,
          StatCard.streak(isSmall: true, days: 2, l10n: l10n),
        );

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text("2")),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.byIcon(Icons.whatshot_rounded)),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.text("of continued learning")),
            findsNothing);
        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
      testWidgets("large", (WidgetTester tester) async {
        final widget = await pump(
          tester,
          StatCard.streak(isSmall: false, days: 2, l10n: l10n),
        );

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text("2 days")),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.byIcon(Icons.whatshot_rounded)),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.text("of continued learning")),
            findsOneWidget);
        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.max);
      });
    });

    group("words", () {
      testWidgets("small", (WidgetTester tester) async {
        final widget = await pump(
          tester,
          StatCard.words(isSmall: true, words: 2, l10n: l10n),
        );

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text("2")),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.byIcon(Icons.translate_rounded)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text("learned")),
            findsNothing);
        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
      testWidgets("large", (WidgetTester tester) async {
        final widget = await pump(
          tester,
          StatCard.words(isSmall: false, words: 2, l10n: l10n),
        );

        expect(widget, findsOneWidget);
        final Card card = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Card)));
        expect(card.color, null);
        expect(find.descendant(of: widget, matching: find.text("2 words")),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.byIcon(Icons.translate_rounded)),
            findsOneWidget);
        expect(find.descendant(of: widget, matching: find.text("learned")),
            findsOneWidget);
        final Row row = tester.firstWidget(
            find.descendant(of: widget, matching: find.byType(Row)));
        expect(row.mainAxisSize, MainAxisSize.max);
      });
    });

    group("timer", () {
      for (final testCase in [
        const StatTimerData(
            Duration(minutes: 1, seconds: 12), "01:12", "01:12"),
        const StatTimerData(
            Duration(minutes: 12, seconds: 12), "12:12", "12:12"),
        const StatTimerData(Duration(minutes: 12), "12:00", "12:00"),
      ]) {
        testWidgets(testCase.testCase, (WidgetTester tester) async {
          final widget = await pump(
            tester,
            StatCard.timer(elapsedTime: testCase.duration),
          );

          expect(widget, findsOneWidget);
          expect(
              find.descendant(
                  of: widget,
                  matching: find.text(testCase.expectedDurationText)),
              findsOneWidget);
          expect(
              find.descendant(
                  of: widget, matching: find.byIcon(Icons.timer_rounded)),
              findsOneWidget);
          final Row row = tester.firstWidget(
              find.descendant(of: widget, matching: find.byType(Row)));
          expect(row.mainAxisSize, MainAxisSize.min);
        });
      }
    });
  });
}
