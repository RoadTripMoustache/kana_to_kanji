import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
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
