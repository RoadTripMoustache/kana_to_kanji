import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_levels.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/widgets/furigana_text.dart';

class GlossaryListTile extends StatelessWidget {
  /// Kanji that is displayed.
  /// Either [kanji] or [vocabulary] must be set the other must be null
  final Kanji? kanji;

  /// Vocabulary that is displayed.
  /// Either [kanji] or [vocabulary] must be set the other must be null
  final Vocabulary? vocabulary;

  /// JLPT level of the kanji or vocabulary
  final int jlptLevel;

  /// Meanings of the kanji or vocabulary
  final List<String> meanings;

  /// Function called when the tile is tapped
  final VoidCallback? onPressed;

  /// Display or not the furigana.
  final bool showFurigana;

  const GlossaryListTile(
      {super.key,
      required this.meanings,
      required this.jlptLevel,
      this.kanji,
      this.vocabulary,
      this.showFurigana = true,
      this.onPressed})
      : assert((kanji == null || vocabulary == null) &&
            (kanji != null || vocabulary != null));

  /// Build a tile for a [Kanji]
  factory GlossaryListTile.kanji(
          {Key? key,
          required Kanji kanji,
          bool showFurigana = true,
          VoidCallback? onPressed}) =>
      GlossaryListTile(
          key: key,
          kanji: kanji,
          meanings: kanji.meanings,
          jlptLevel: kanji.jlptLevel,
          showFurigana: showFurigana,
          onPressed: onPressed);

  /// Build a tile for a [Vocabulary]
  factory GlossaryListTile.vocabulary(
          {Key? key,
          required Vocabulary vocabulary,
          bool showFurigana = true,
          VoidCallback? onPressed}) =>
      GlossaryListTile(
          key: key,
          vocabulary: vocabulary,
          meanings: vocabulary.meanings,
          jlptLevel: vocabulary.jlptLevel,
          showFurigana: showFurigana,
          onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? titleStyle =
        textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final AppLocalizations l10n = AppLocalizations.of(context);

    final furiganaText = kanji != null
        ? FuriganaText.kanji(kanji!,
            showFurigana: showFurigana, style: titleStyle)
        : FuriganaText.vocabulary(vocabulary!,
            showFurigana: showFurigana, style: titleStyle);

    return Card(
      child: ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            furiganaText,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                l10n.glossary_tile_meanings(meanings[0], meanings.length - 1),
                overflow: TextOverflow.ellipsis,
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
        subtitle: Row(
          children: [
            Badge(
              backgroundColor: JLPTLevelColors.level(jlptLevel),
              label: Text(
                l10n.jlpt_level_short(jlptLevel),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        trailing: onPressed != null
            ? IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: onPressed,
              )
            : null,
      ),
    );
  }
}
