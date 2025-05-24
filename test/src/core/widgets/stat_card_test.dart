import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";
import "package:kana_to_kanji/src/core/widgets/stat_card.dart";

import "../../../helpers.dart";

void main() {
  group("StatCard", () {
    late final AppLocalizations l10n;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    group("StreakStatCard", () {
      Future<Finder> pump(WidgetTester tester, Widget widget) async {
        await tester.pumpLocalizedWidget(widget);
        await tester.pumpAndSettle();

        return find.byType(StreakStatCard);
      }

      testWidgets("should display streak count", (WidgetTester tester) async {
        const count = 5;

        final widget = await pump(tester, const StreakStatCard(count: count));

        expect(widget, findsOneWidget);
        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_streak(count)),
          ),
          findsOneWidget,
          reason: "Should display the streak count with proper formatting",
        );
      });

      testWidgets("should display streak count in dense mode", (
        WidgetTester tester,
      ) async {
        const count = 5;

        final widget = await pump(
          tester,
          const StreakStatCard(count: count, dense: true),
        );

        expect(widget, findsOneWidget);
        expect(
          find.descendant(of: widget, matching: find.text(count.toString())),
          findsOneWidget,
          reason: "Should display only the count in dense mode",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_streak_subtitle),
          ),
          findsNothing,
          reason: "Should not display the subtitle in dense mode",
        );
      });

      testWidgets("should display subtitle when not in dense mode", (
        WidgetTester tester,
      ) async {
        const count = 5;

        final widget = await pump(tester, const StreakStatCard(count: count));

        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_streak_subtitle),
          ),
          findsOneWidget,
          reason: "Should display the subtitle in normal mode",
        );
      });

      testWidgets("should have fire icon with correct color", (
        WidgetTester tester,
      ) async {
        const count = 5;

        final widget = await pump(tester, const StreakStatCard(count: count));

        final iconFinder = find.descendant(
          of: widget,
          matching: find.byIcon(Icons.whatshot_rounded),
        );

        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.color, AppTheme.red[500]);
      });
    });

    group("WordsStatCard", () {
      Future<Finder> pump(WidgetTester tester, Widget widget) async {
        await tester.pumpLocalizedWidget(widget);
        await tester.pumpAndSettle();

        return find.byType(WordsStatCard);
      }

      testWidgets("should display word count", (WidgetTester tester) async {
        const count = 10;

        final widget = await pump(tester, const WordsStatCard(count: count));

        expect(widget, findsOneWidget);
        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_words(count)),
          ),
          findsOneWidget,
          reason: "Should display the word count with proper formatting",
        );
      });

      testWidgets("should display word count in dense mode", (
        WidgetTester tester,
      ) async {
        const count = 10;

        final widget = await pump(
          tester,
          const WordsStatCard(count: count, dense: true),
        );

        expect(widget, findsOneWidget);
        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_words_dense(count)),
          ),
          findsOneWidget,
          reason: "Should display the dense format in dense mode",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_words_subtitle),
          ),
          findsNothing,
          reason: "Should not display the subtitle in dense mode",
        );
      });

      testWidgets("should display subtitle when not in dense mode", (
        WidgetTester tester,
      ) async {
        const count = 10;

        final widget = await pump(tester, const WordsStatCard(count: count));

        expect(
          find.descendant(
            of: widget,
            matching: find.text(l10n.stat_card_words_subtitle),
          ),
          findsOneWidget,
          reason: "Should display the subtitle in normal mode",
        );
      });

      testWidgets(
        "should have translate icon with correct color in light mode",
        (WidgetTester tester) async {
          const count = 10;

          final widget = await pump(tester, const WordsStatCard(count: count));

          final iconFinder = find.descendant(
            of: widget,
            matching: find.byIcon(Icons.translate_outlined),
          );

          expect(iconFinder, findsOneWidget);

          final icon = tester.widget<Icon>(iconFinder);
          expect(icon.color, AppTheme.purple[900]);
        },
      );

      testWidgets(
        "should have translate icon with correct color in dark mode",
        (WidgetTester tester) async {
          const count = 10;

          await tester.pumpLocalizedWidget(
            const WordsStatCard(count: count),
            themeMode: ThemeMode.dark,
          );
          await tester.pumpAndSettle();

          final widget = find.byType(WordsStatCard);
          final iconFinder = find.descendant(
            of: widget,
            matching: find.byIcon(Icons.translate_outlined),
          );

          expect(iconFinder, findsOneWidget);

          final icon = tester.widget<Icon>(iconFinder);
          expect(icon.color, AppTheme.purple[300]);
        },
      );
    });

    group("TimerStatCard", () {
      Future<Finder> pump(WidgetTester tester, Widget widget) async {
        await tester.pumpLocalizedWidget(widget);
        await tester.pumpAndSettle();

        return find.byType(TimerStatCard);
      }

      testWidgets("should display formatted duration", (
        WidgetTester tester,
      ) async {
        final duration = Duration(minutes: 5, seconds: 30);

        final widget = await pump(tester, TimerStatCard(duration: duration));

        expect(widget, findsOneWidget);
        expect(
          find.descendant(of: widget, matching: find.text("05:30")),
          findsOneWidget,
          reason: "Should display the formatted duration",
        );
      });

      testWidgets("should have timer icon with correct color in light mode", (
        WidgetTester tester,
      ) async {
        final duration = Duration(minutes: 5, seconds: 30);

        final widget = await pump(tester, TimerStatCard(duration: duration));

        final iconFinder = find.descendant(
          of: widget,
          matching: find.byIcon(Icons.timer_rounded),
        );

        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.color, AppTheme.purple[900]);
      });

      testWidgets("should have timer icon with correct color in dark mode", (
        WidgetTester tester,
      ) async {
        final duration = Duration(minutes: 5, seconds: 30);

        await tester.pumpLocalizedWidget(
          TimerStatCard(duration: duration),
          themeMode: ThemeMode.dark,
        );
        await tester.pumpAndSettle();

        final widget = find.byType(TimerStatCard);
        final iconFinder = find.descendant(
          of: widget,
          matching: find.byIcon(Icons.timer_rounded),
        );

        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.color, AppTheme.purple[300]);
      });
    });
  });
}
