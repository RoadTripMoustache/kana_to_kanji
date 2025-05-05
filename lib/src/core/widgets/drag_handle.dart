import "dart:math" as math;

import "package:flutter/material.dart";

const _dragHangleSize = Size(32, 4);

class DragHandle extends StatelessWidget {
  const DragHandle({
    super.key,
    this.onSemanticsTap,
    this.dragHandleColor,
    this.dragHandleSize,
  });

  final VoidCallback? onSemanticsTap;
  final Color? dragHandleColor;
  final Size? dragHandleSize;

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme =
        Theme.of(context).bottomSheetTheme;
    final handleColor =
        dragHandleColor ??
        bottomSheetTheme.dragHandleColor ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    final Size handleSize =
        dragHandleSize ?? bottomSheetTheme.dragHandleSize ?? _dragHangleSize;

    return Semantics(
      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      container: true,
      onTap: onSemanticsTap,
      child: SizedBox(
        width: math.max(handleSize.width, kMinInteractiveDimension),
        height: math.max(handleSize.height, kMinInteractiveDimension),
        child: Center(
          child: Container(
            height: handleSize.height,
            width: handleSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(handleSize.height / 2),
              color: handleColor,
            ),
          ),
        ),
      ),
    );
  }
}
