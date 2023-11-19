import 'package:flutter/material.dart';

class VocabularyListTile extends StatelessWidget {
  final String data;

  const VocabularyListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}
