import "package:flutter/material.dart";

class ConfirmationDialog extends StatelessWidget {
  /// Title of the dialog to display
  final String title;

  /// Message content of the dialog to display
  final String content;

  /// Label to use for the "cancellation" button.
  final String cancelButtonLabel;

  /// Label to use for the "validation" button.
  final String validationButtonLabel;

  /// Function to call when the user click on the "cancellation" button.
  final void Function() cancel;

  /// Function to call when the user click on the "validation" button.
  final void Function() validate;

  const ConfirmationDialog(
      {required this.title,
      required this.content,
      required this.cancelButtonLabel,
      required this.validationButtonLabel,
      required this.cancel,
      required this.validate,
      super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: cancel,
            child: Text(cancelButtonLabel),
          ),
          TextButton(
            onPressed: validate,
            child: Text(validationButtonLabel),
          ),
        ],
      );
}
