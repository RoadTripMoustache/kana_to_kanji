import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/widgets/furigana_text.dart';

class KanjiListTile extends StatelessWidget {
  final Kanji kanji;

  final bool showFurigana;

  const KanjiListTile(
      {super.key, required this.kanji, this.showFurigana = true});

  @override
  Widget build(BuildContext context) {
    final TextStyle? kanjiStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold);
    final TextStyle? textTheme = Theme.of(context).textTheme.titleSmall;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      child: ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FuriganaText.kanji(
              kanji: kanji,
              showFurigana: showFurigana,
              style: kanjiStyle,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.glossary_tile_meanings(
                  kanji.meanings[0], kanji.meanings.length - 1),
              style: textTheme?.copyWith(fontWeight: FontWeight.normal),
            )
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
