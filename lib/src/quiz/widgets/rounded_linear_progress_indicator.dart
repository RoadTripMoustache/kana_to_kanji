import 'package:flutter/material.dart';

class RoundedLinearProgressIndicator extends StatelessWidget {
  final double? minHeight;
  final double value;

  const RoundedLinearProgressIndicator(
      {super.key, this.minHeight, this.value = 0.0})
      : assert(minHeight == null || minHeight > 0);

  @override
  Widget build(BuildContext context) {
    final minHeight = this.minHeight ?? Theme
        .of(context)
        .progressIndicatorTheme
        .linearMinHeight ?? 4.0;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(minHeight / 2)),
      child: LinearProgressIndicator(
        minHeight: minHeight,
        value: value,
      ),
    );
  }
}
