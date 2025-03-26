import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class ButtonItem extends StatelessWidget {
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  const ButtonItem({required this.onPressed, required this.child, super.key});

  @override
  Widget build(BuildContext context) => RTMListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    title: RTMFilledButton(onPressed: onPressed, child: child),
  );
}
