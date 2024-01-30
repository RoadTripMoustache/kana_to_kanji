import 'package:flutter/material.dart';

class PronunciationCard extends StatelessWidget {
  final String pronunciation;

  final VoidCallback? onPressed;

  const PronunciationCard({super.key, required this.pronunciation, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        avatar: const Icon(Icons.volume_up_rounded),
        label: Text(pronunciation),
        onPressed: onPressed);
  }
}
