import 'package:flutter/material.dart';

class KanjiListTile extends StatelessWidget {
  final String data;

  const KanjiListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}
