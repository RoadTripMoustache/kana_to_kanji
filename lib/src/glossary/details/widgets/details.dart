import "dart:math";

import "package:flutter/material.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/section_title.dart";

class Details extends StatelessWidget {
  final List<PronunciationDetails> pronunciations;

  final ScrollController scrollController;

  /// The kanji or vocabulary in japanese not the reading
  /// Used to determine which part of the sentence in examples to bold
  final String toBold;

  final Future Function(String reading) onSpeakerPressed;

  const Details({
    required this.scrollController,
    required this.pronunciations,
    required this.toBold,
    required this.onSpeakerPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    final longestText = pronunciations
        .map((pronunciation) => pronunciation.reading)
        .reduce((a, b) => a.length > b.length ? a : b);
    final double longestTextWidth = _determineLongestTitleWidth(
      longestText,
      theme.textTheme.titleSmall!,
    );

    final int meanings = pronunciations
        .map((pronunciation) => pronunciation.meanings)
        .fold(0, (count, meaning) => count + meaning.length);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: SectionTitle(
            title: l10n.glossary_details_readings_and_meanings(
              pronunciations.length,
              meanings,
            ),
            style: theme.textTheme.titleLarge,
          ),
        ),
        SliverList.builder(
          itemCount: pronunciations.length,
          itemBuilder:
              (context, index) => PronunciationCard.fromPronunciationDetails(
                pronunciation: pronunciations[index],
                toBold: toBold,
                pronunciationMinWidth: longestTextWidth,
                onSpeakerPressed: onSpeakerPressed,
              ),
        ),
      ],
    );
  }

  double _determineLongestTitleWidth(
    String text,
    TextStyle style, {
    int maxLines = 1,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout();

    return max(textPainter.size.width, 48.0);
  }
}
