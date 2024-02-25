import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/details.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/section_title.dart';

import '../../../../helpers.dart';

void main() {
  group("Details", () {
    late final AppLocalizations l10n;

    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(Details);
    }

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    testWidgets("Kana", (WidgetTester tester) async {
      const kanaSample = Kana(0, Alphabets.hiragana, 0, "あ", "a", "2023-12-01");

      final widget = await pump(tester, Details.kana(kana: kanaSample));

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitle = find.byType(SectionTitle);
      expect(sectionTitle, findsOneWidget,
          reason:
              "Should only have the pronunciation section as Kana don't have meanings");
      expect(tester.widget<SectionTitle>(sectionTitle).title,
          equals(l10n.glossary_details_pronunciation(1)));

      // Check pronunciation cards
      final pronunciationCard = find.byType(PronunciationCard);
      expect(pronunciationCard, findsOneWidget);
      expect(tester.widget<PronunciationCard>(pronunciationCard).pronunciation,
          equals(kanaSample.romaji));
    });

    testWidgets("Kanji", (WidgetTester tester) async {
      const kanjiSample =
          Kanji(1, "本", 5, 5, 5, ["book"], ["ほん"], ["ほん"], [], "2023-12-1", [], [], []);

      final widget = await pump(tester, Details.kanji(kanji: kanjiSample));

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitles = find.byType(SectionTitle);
      expect(sectionTitles, findsNWidgets(2),
          reason: "Should the pronunciation and meaning section");
      expect(
          tester
              .widgetList<SectionTitle>(sectionTitles)
              .map((sectionTitle) => sectionTitle.title),
          equals([
            l10n.glossary_details_pronunciation(kanjiSample.readings.length),
            l10n.glossary_details_meaning(kanjiSample.meanings.length)
          ]),
          reason:
              "Should have the pronunciation section than the meaning section");

      // Check the pronunciation section
      expect(find.widgetWithText(PronunciationCard, "ほん"), findsNWidgets(2));

      // Check the meaning section
      expect(find.byType(Chip), findsNWidgets(kanjiSample.meanings.length));
      for (final String meaning in kanjiSample.meanings) {
        expect(find.widgetWithText(Chip, meaning), findsOneWidget);
      }
    });

    testWidgets("Vocabulary", (WidgetTester tester) async {
      const vocabularySample =
          Vocabulary(1, "亜", "あ", 1, ["inferior"], "a", [], "2023-12-1", [], []);

      final widget =
          await pump(tester, Details.vocabulary(vocabulary: vocabularySample));

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitles = find.byType(SectionTitle);
      expect(sectionTitles, findsNWidgets(2),
          reason: "Should the pronunciation and meaning section");
      expect(
          tester
              .widgetList<SectionTitle>(sectionTitles)
              .map((sectionTitle) => sectionTitle.title),
          equals([
            l10n.glossary_details_pronunciation(1),
            l10n.glossary_details_meaning(vocabularySample.meanings.length)
          ]),
          reason:
              "Should have the pronunciation section than the meaning section");

      // Check the pronunciation section
      expect(find.widgetWithText(PronunciationCard, vocabularySample.kana),
          findsOneWidget);

      // Check the meaning section
      expect(
          find.byType(Chip), findsNWidgets(vocabularySample.meanings.length));
      for (final String meaning in vocabularySample.meanings) {
        expect(find.widgetWithText(Chip, meaning), findsOneWidget);
      }
    });
  });
}
