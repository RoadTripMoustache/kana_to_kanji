import "package:flutter/material.dart";

class PronunciationCard extends StatelessWidget {
  final String pronunciation;

  const PronunciationCard({required this.pronunciation, super.key});

  void _onPressed() {
    // TODO if selected == true -> read pronunciation
  }

  @override
  Widget build(BuildContext context) => ActionChip(
    avatar: const Icon(Icons.volume_up_rounded),
    label: Text(pronunciation),
    onPressed: _onPressed,
  );
}
