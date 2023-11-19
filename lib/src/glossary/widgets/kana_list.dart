import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

class KanaList extends StatelessWidget {
  final List<Kana> dataList;

  const KanaList({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: SingleChildScrollView(
      child: Column(
          children: List.generate(dataList.length,
              (index) => KanaListTile(data: dataList[index].kana))),
    ));
  }
}
