import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:intl/intl.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";

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
