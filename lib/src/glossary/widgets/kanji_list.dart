import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kanji_list_tile.dart';

class KanjiList extends StatelessWidget {
  final List<Kanji> items;

  const KanjiList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => KanjiListTile(kanji: items[index]));
  }
}
