import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:upgrader/upgrader.dart";

class AppSnackBarUpgrader extends UpgradeAlert {
  AppSnackBarUpgrader({
    super.key,
    super.navigatorKey,
    super.upgrader,
    super.child,
  });

  /// Override the [createState] method to provide a custom class
  /// with overridden methods.
  @override
  UpgradeAlertState createState() => AppSnackBarUpgraderState();
}

class AppSnackBarUpgraderState extends UpgradeAlertState {
  /// Show the snack bar to inform the user that a new version
  /// of the app is available.
  @override
  void showTheDialog({
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool barrierDismissible,
    required UpgraderMessages messages,
    Key? key,
  }) {
    final l10n = AppLocalizations.of(context);
    final snackBar = SnackBar(
      content: Text(l10n.snackbar_update_version_message),
      action: SnackBarAction(
        label: l10n.snackbar_update_version_action,
        onPressed: () {
          onUserUpdated(context, !widget.upgrader.blocked());
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
