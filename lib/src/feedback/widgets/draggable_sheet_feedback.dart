import 'package:flutter/material.dart';

class DraggableSheetFeedback extends StatelessWidget {
  final Widget child;

  const DraggableSheetFeedback({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isKeyboardShown = MediaQuery.of(context).viewInsets.bottom > 0;

    // Maximum height of the sheet. If the virtual keyboard is shown we don't
    // want to have the entire sheet moving on top of the keyboard but just a small
    // part of it.
    final double maxHeight = isKeyboardShown
        ? (mediaQuery.size.height - mediaQuery.viewInsets.bottom) * 0.5
        : double.infinity;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: mediaQuery.viewInsets.bottom),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(child: child)),
      ),
    );
  }
}
