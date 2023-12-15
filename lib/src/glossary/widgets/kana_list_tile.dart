import 'package:flutter/material.dart';

class KanaListTile extends StatelessWidget {
  final String data;

  const KanaListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}
