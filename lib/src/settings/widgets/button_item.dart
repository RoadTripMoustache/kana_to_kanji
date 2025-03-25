import "package:flutter/material.dart";

class ButtonItem extends StatelessWidget {
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  const ButtonItem({required this.onPressed, required this.child, super.key});

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    title: ElevatedButton(onPressed: onPressed, child: child),
  );
}
