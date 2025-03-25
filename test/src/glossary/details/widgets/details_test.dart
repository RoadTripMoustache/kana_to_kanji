import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/section_title.dart";

import "../../../../dummies/kana.dart";
import "../../../../dummies/kanji.dart";
import "../../../../dummies/vocabulary.dart";
import "../../../../helpers.dart";

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
      final widget = await pump(tester, Details.kana(kana: dummyHiragana));

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitle = find.byType(SectionTitle);
      expect(
        sectionTitle,
        findsOneWidget,
        reason:
            "Should only have the pronunciation section as Kana "
            "don't have meanings",
      );
      expect(
        tester.widget<SectionTitle>(sectionTitle).title,
        equals(l10n.glossary_details_pronunciation(1)),
      );

      // Check pronunciation cards
      final pronunciationCard = find.byType(PronunciationCard);
      expect(pronunciationCard, findsOneWidget);
      expect(
        tester.widget<PronunciationCard>(pronunciationCard).pronunciation,
        equals(dummyHiragana.romaji),
      );
    });

    testWidgets("Kanji", (WidgetTester tester) async {
      final widget = await pump(tester, Details.kanji(kanji: dummyKanji));

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitles = find.byType(SectionTitle);
      expect(
        sectionTitles,
        findsNWidgets(2),
        reason: "Should the pronunciation and meaning section",
      );
      expect(
        tester
            .widgetList<SectionTitle>(sectionTitles)
            .map((sectionTitle) => sectionTitle.title),
        equals([
          l10n.glossary_details_pronunciation(dummyKanji.readings.length),
          l10n.glossary_details_meaning(dummyKanji.meanings.length),
        ]),
        reason:
            "Should have the pronunciation section than the meaning section",
      );

      // Check the pronunciation section
      expect(find.widgetWithText(PronunciationCard, "ほん"), findsNWidgets(2));

      // Check the meaning section
      expect(find.byType(Chip), findsNWidgets(dummyKanji.meanings.length));
      for (final String meaning in dummyKanji.meanings) {
        expect(find.widgetWithText(Chip, meaning), findsOneWidget);
      }
    });

    testWidgets("Vocabulary", (WidgetTester tester) async {
      final widget = await pump(
        tester,
        Details.vocabulary(vocabulary: dummyVocabulary),
      );

      expect(widget, findsOneWidget);

      // Check section titles
      final sectionTitles = find.byType(SectionTitle);
      expect(
        sectionTitles,
        findsNWidgets(2),
        reason: "Should the pronunciation and meaning section",
      );
      expect(
        tester
            .widgetList<SectionTitle>(sectionTitles)
            .map((sectionTitle) => sectionTitle.title),
        equals([
          l10n.glossary_details_pronunciation(1),
          l10n.glossary_details_meaning(dummyVocabulary.meanings.length),
        ]),
        reason:
            "Should have the pronunciation section than the meaning section",
      );

      // Check the pronunciation section
      expect(
        find.widgetWithText(PronunciationCard, dummyVocabulary.kana),
        findsOneWidget,
      );

      // Check the meaning section
      expect(find.byType(Chip), findsNWidgets(dummyVocabulary.meanings.length));
      for (final String meaning in dummyVocabulary.meanings) {
        expect(find.widgetWithText(Chip, meaning), findsOneWidget);
      }
    });
  });
}
