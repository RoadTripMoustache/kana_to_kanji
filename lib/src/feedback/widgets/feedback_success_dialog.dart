import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FeedbackSuccessDialog extends StatelessWidget {
  const FeedbackSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.done_rounded, color: Colors.green, size: 52),
                Text(AppLocalizations.of(context).feedback_thanks,
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ],
        ),
      );
}
