import 'package:flutter/material.dart';

class ButtonItem extends StatelessWidget {
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  const ButtonItem({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
