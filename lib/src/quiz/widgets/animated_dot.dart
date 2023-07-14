import 'package:flutter/material.dart';

class AnimatedDot extends StatelessWidget {
  final Color color;

  final bool filledOut;

  const AnimatedDot(
      {super.key, this.color = Colors.grey, this.filledOut = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filledOut ? color : Colors.transparent,
          border: Border.all(color: color)),
    );
  }
}
