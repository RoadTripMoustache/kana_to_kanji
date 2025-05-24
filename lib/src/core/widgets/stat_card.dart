import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:intl/intl.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";

class StreakStatCard extends StatelessWidget {
  final int count;

  final bool dense;

  const StreakStatCard({required this.count, this.dense = false, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return RTMBadge(
      icon: Icon(Icons.whatshot_rounded, color: AppTheme.red[500]),
      label: Text(dense ? count.toString() : l10n.stat_card_streak(count)),
      secondaryLabel: dense ? null : Text(l10n.stat_card_streak_subtitle),
    );
  }
}

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

class TimerStatCard extends StatelessWidget {
  final Duration duration;

  const TimerStatCard({required this.duration, super.key});

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final iconColor = lightMode ? AppTheme.purple[900] : AppTheme.purple[300];

    final dateTime = DateTime(
      2025,
      1,
      1,
      1,
      duration.inMinutes % 60,
      duration.inSeconds % 60,
    );
    final formatter = DateFormat.ms();

    return RTMBadge(
      icon: Icon(Icons.timer_rounded, color: iconColor),
      label: Text(formatter.format(dateTime)),
    );
  }
}
