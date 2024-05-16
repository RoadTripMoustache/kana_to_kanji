import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

class KanjiList extends StatelessWidget {
  final List<Kanji> items;

  /// Function to execute when a [GlossaryListTile] is pressed
  final Function(Kanji kanji)? onPressed;

  const KanjiList({super.key, required this.items, this.onPressed});

  void _onPressed(Kanji kanji) {
    if (onPressed != null) {
      onPressed!(kanji);
    }
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      key: const PageStorageKey("glossary_kanji_list"),
      itemCount: items.length,
      itemBuilder: (context, index) => GlossaryListTile.kanji(items[index],
          onPressed: () => _onPressed(items[index])));
}
