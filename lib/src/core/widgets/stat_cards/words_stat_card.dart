import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";

class WordsStatCard extends StatelessWidget {
  final int count;

  final bool dense;

  final bool newWords;

  const WordsStatCard({
    required this.count,
    this.dense = false,
    this.newWords = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final iconColor = lightMode ? AppTheme.purple[900] : AppTheme.purple[300];

    return RTMBadge(
      icon: Icon(Icons.translate_outlined, color: iconColor),
      label: Text(
        dense ? l10n.stat_card_words_dense(count) : l10n.stat_card_words(count),
      ),
      secondaryLabel: dense ? null : Text(l10n.stat_card_words_subtitle),
    );
  }
}
