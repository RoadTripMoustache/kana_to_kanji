import "package:flutter/material.dart";

class ToasterService {
  /// toast - To toast a message to the screen.
  /// If is there no [actionLabel] the [SnackBarAction] won't be added.
  /// params :
  /// - message: Message to display in the snack bar
  /// - actionLabel: Label to use for the action label.
  /// - onPressed: Method to execute if the action button
  /// is pressed.
  void toast(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onPressed,
  }) {
    SnackBarAction? action;

    if (actionLabel != null) {
      action = SnackBarAction(label: actionLabel, onPressed: onPressed!);
    }

    final snackBar = SnackBar(content: Text(message), action: action);

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
