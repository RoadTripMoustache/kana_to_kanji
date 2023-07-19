import 'package:flutter/material.dart';

class RoundedLinearProgressIndicator extends StatelessWidget {
  final double? minHeight;
  final double value;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  const RoundedLinearProgressIndicator(
      {super.key,
      this.minHeight,
      this.value = 0.0,
      this.backgroundColor,
      this.valueColor,
      this.semanticsLabel,
      this.semanticsValue})
      : assert(minHeight == null || minHeight > 0);

  @override
  Widget build(BuildContext context) {
    final minHeight = this.minHeight ??
        Theme.of(context).progressIndicatorTheme.linearMinHeight ??
        4.0;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(minHeight / 2)),
      child: LinearProgressIndicator(
        minHeight: minHeight,
        value: value,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}
