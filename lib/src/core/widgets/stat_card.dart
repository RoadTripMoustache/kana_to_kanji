import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class StatCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String? subtitle;
  final bool isSmall;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  static const double iconSize = 24.0;

  const StatCard(
      {required this.icon,
      required this.title,
      required this.isSmall,
      this.subtitle,
      this.backgroundColor,
      this.titleTextStyle,
      this.subtitleTextStyle,
      super.key});

  factory StatCard.small({
    required Icon icon,
    required String title,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) =>
      StatCard(
        icon: icon,
        title: title,
        isSmall: true,
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
      );

  factory StatCard.large({
    required Icon icon,
    required String title,
    String? subtitle,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) =>
      StatCard(
        icon: icon,
        title: title,
        subtitle: subtitle,
        isSmall: false,
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
      );

  factory StatCard.streak({
    required bool isSmall,
    required int days,
    required AppLocalizations l10n,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    final title = isSmall ? "$days" : l10n.streak_title(days);

    return StatCard(
      icon: const Icon(
        Icons.whatshot_rounded,
        color: Colors.red,
        size: iconSize,
      ),
      title: title,
      subtitle: l10n.streak_label,
      isSmall: isSmall,
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
    );
  }

  factory StatCard.timer({
    required Duration elapsedTime,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    final durationMinutes =
        elapsedTime.inMinutes.remainder(60).toString().padLeft(2, "0");
    final durationSeconds =
        elapsedTime.inSeconds.remainder(60).toString().padLeft(2, "0");
    return StatCard(
      icon: const Icon(
        Icons.timer_rounded,
        size: iconSize,
      ),
      title: "$durationMinutes:$durationSeconds",
      isSmall: true,
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
    );
  }

  factory StatCard.words({
    required bool isSmall,
    required int words,
    required AppLocalizations l10n,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    final title = isSmall ? "$words" : l10n.nbr_words(words);
    return StatCard(
        icon: const Icon(
          Icons.translate_rounded,
          size: iconSize,
        ),
        title: title,
        subtitle: l10n.words_learned,
        isSmall: isSmall,
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle);
  }

  @override
  Widget build(BuildContext context) {
    final statCard = Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: isSmall ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: icon,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: titleTextStyle ??
                            Theme.of(context).textTheme.bodyMedium),
                    if (!isSmall && subtitle != null)
                      Text(subtitle ?? "",
                          style: subtitleTextStyle ??
                              Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );

    if (isSmall) {
      return statCard;
    } else {
      return Expanded(child: statCard);
    }
  }
}
