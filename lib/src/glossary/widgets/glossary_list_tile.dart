import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";

class GlossaryListTile extends StatelessWidget {
  /// Either a [Kanji] or [Vocabulary].
  final Resource item;

  final String japanese;

  /// JLPT level of the kanji or vocabulary
  final int jlptLevel;

  /// Meanings of the kanji or vocabulary
  final List<String> meanings;

  /// Function called when the tile is tapped
  final VoidCallback? onTap;

  const GlossaryListTile({
    required this.item,
    required this.japanese,
    required this.meanings,
    required this.jlptLevel,
    super.key,
    this.onTap,
  }) : assert(
         item is Kanji || item is Vocabulary,
         "item must be a Kanji or a Vocabulary",
       );

  /// Build a tile for a [Kanji]
  factory GlossaryListTile.kanji(
    Kanji kanji, {
    Key? key,
    VoidCallback? onPressed,
  }) => GlossaryListTile(
    key: key,
    item: kanji,
    japanese: kanji.kanji,
    meanings: kanji.meanings,
    jlptLevel: kanji.jlptLevel,
    onTap: onPressed,
  );

  /// Build a tile for a [Vocabulary]
  factory GlossaryListTile.vocabulary(
    Vocabulary vocabulary, {
    Key? key,
    VoidCallback? onPressed,
  }) => GlossaryListTile(
    key: key,
    item: vocabulary,
    japanese: vocabulary.japanese,
    meanings: vocabulary.meanings,
    jlptLevel: vocabulary.jlptLevel,
    onTap: onPressed,
  );

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? titleStyle = textTheme.titleLarge;
    final TextStyle? trailingStyle = textTheme.headlineSmall?.copyWith(
      color: JLPTLevelColors.level(jlptLevel),
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return RTMListTile(
      dense: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(japanese, style: titleStyle),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              l10n.glossary_tile_meanings(meanings[0], meanings.length - 1),
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      trailing: Text(l10n.jlpt_level_short(jlptLevel), style: trailingStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: onTap,
    );
  }
}
