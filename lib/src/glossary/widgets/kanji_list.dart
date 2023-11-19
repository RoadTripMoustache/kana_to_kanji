import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kanji_list_tile.dart';

class KanjiList extends StatelessWidget {
  final List<Kanji> dataList;

  const KanjiList({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: SingleChildScrollView(
      child: Column(
          children: List.generate(dataList.length,
              (index) => KanjiListTile(data: dataList[index].kanji))),
    ));
  }
}
