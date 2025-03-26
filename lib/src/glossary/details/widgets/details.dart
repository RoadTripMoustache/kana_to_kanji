import "package:flutter/material.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/widgets/app_spacer.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/section_title.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/wrapped_list.dart";

class Details extends StatelessWidget {
  /// All the pronunciations of the word.
  final List<String> pronunciations;

  /// All the meanings for the word.
  /// If empty, the meanings section will be hidden
  final List<String> meanings;

  const Details._({
    required this.pronunciations,
    super.key,
    this.meanings = const [],
  });

  /// Build the details card for a [Kana].
  factory Details.kana({required Kana kana, Key? key}) =>
      Details._(key: key, pronunciations: [kana.romaji]);

  /// Build the details card for a [Kanji].
  factory Details.kanji({required Kanji kanji, Key? key}) => Details._(
    key: key,
    pronunciations: kanji.readings,
    meanings: kanji.meanings,
  );

  /// Build the details card for a [Vocabulary].
  factory Details.vocabulary({required Vocabulary vocabulary, Key? key}) =>
      Details._(
        key: key,
        pronunciations: [vocabulary.kana],
        meanings: vocabulary.meanings,
      );

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionTitle(
              title: l10n.glossary_details_pronunciation(pronunciations.length),
            ),
            WrappedList(
              children: pronunciations
                  .map((e) => PronunciationCard(pronunciation: e))
                  .toList(growable: false),
            ),
          ],
        ),
        if (meanings.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacer.p16(),
              SectionTitle(
                title: l10n.glossary_details_meaning(meanings.length),
              ),
              WrappedList(
                children: meanings
                    .map((e) => Chip(label: Text(e)))
                    .toList(growable: false),
              ),
            ],
          ),
        AppSpacer.p40(),
      ],
    );
  }
}
