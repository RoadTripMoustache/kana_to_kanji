import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

class KanaList extends StatelessWidget {
  final List<Kana> items;

  const KanaList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(items.length,
              (index) => KanaListTile(data: items[index].kana))),
    );
  }
}
