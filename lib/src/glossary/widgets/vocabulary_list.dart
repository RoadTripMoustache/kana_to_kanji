import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_list_tile.dart';

class VocabularyList extends StatelessWidget {
  final List<Vocabulary> items;

  const VocabularyList({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: SingleChildScrollView(
      child: Column(
          children: List.generate(dataList.length,
              (index) => VocabularyListTile(data: dataList[index].romaji))),
    ));
  }
}
