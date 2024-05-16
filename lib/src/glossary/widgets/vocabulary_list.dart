import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

class VocabularyList extends StatelessWidget {
  final List<Vocabulary> items;

  /// Function to execute when a [GlossaryListTile] is pressed
  final Function(Vocabulary vocabulary)? onPressed;

  const VocabularyList({required this.items, super.key, this.onPressed});

  void _onPressed(Vocabulary vocabulary) {
    onPressed?.call(vocabulary);
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      key: const PageStorageKey("glossary_vocabulary_list"),
      itemCount: items.length,
      itemBuilder: (context, index) => GlossaryListTile.vocabulary(items[index],
          onPressed: () => _onPressed(items[index])));
}
