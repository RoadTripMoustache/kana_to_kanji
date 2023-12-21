import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';

class KanaListTile extends StatelessWidget {
  final Kana kana;

  final VoidCallback? onPressed;

  const KanaListTile(this.kana, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kanaStyle = textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

    return Card(
        child: InkWell(
          onTap: onPressed,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(kana.kana,
                    style: kanaStyle),
                Text(kana.romaji, style: textTheme.bodyMedium)
              ]),
        ));
  }
}
