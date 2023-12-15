import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart';

class VocabularyList extends StatelessWidget {
  final List<Vocabulary> items;

  const VocabularyList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: const PageStorageKey("glossary_vocabulary_list"),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            GlossaryListTile.vocabulary(vocabulary: items[index]));
  }
}
