import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart';

class VocabularyList extends StatelessWidget {
  final List<Vocabulary> items;

  const VocabularyList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(
              items.length,
              (index) =>
                  GlossaryListTile.vocabulary(vocabulary: items[index]))),
    );
  }
}
