import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";

class KanaListTile extends StatelessWidget {
  final Kana kana;

  final VoidCallback? onPressed;

  final bool disabled;

  const KanaListTile(
    this.kana, {
    super.key,
    this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    final textTheme = Theme.of(context).textTheme;
    final kanaStyle = textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: disabled ? disabledColor : null,
    );
    final romajiStyle = textTheme.bodyMedium?.copyWith(
      color: disabled ? disabledColor : null,
    );

    return Card(
      elevation: disabled ? 0 : 1.0,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(kana.kana, style: kanaStyle),
            Text(kana.romaji, style: romajiStyle),
          ],
        ),
      ),
    );
  }
}
