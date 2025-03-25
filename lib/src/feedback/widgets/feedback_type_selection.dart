import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/feedback/constants/feedback_type.dart";

/// Size of the leading icon on the buttons
const _kButtonLeadingIconSize = 36.0;

/// Show buttons for each type of feedback available
class FeedbackTypeSelection extends StatelessWidget {
  @visibleForTesting
  static const Key reportBugButtonKey = Key("report_bug_button");
  @visibleForTesting
  static const Key featureRequestButtonKey = Key("feature_request_button");

  final Function(FeedbackType) onPressed;

  const FeedbackTypeSelection({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FilledButton.icon(
            key: reportBugButtonKey,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            onPressed: () => onPressed(FeedbackType.bug),
            icon: const Icon(
              Icons.bug_report_rounded,
              size: _kButtonLeadingIconSize,
            ),
            label: ListTile(
              title: Text(l10n.feedback_report_bug),
              subtitle: Text(l10n.feedback_report_bug_subtitle),
            ),
          ),
        ),
        FilledButton.icon(
          key: featureRequestButtonKey,
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
          icon: const Icon(
            Icons.design_services_rounded,
            size: _kButtonLeadingIconSize,
          ),
          onPressed: () => onPressed(FeedbackType.featureRequest),
          label: ListTile(
            textColor: Colors.white,
            title: Text(l10n.feedback_request_feature),
            subtitle: Text(l10n.feedback_request_feature_subtitle),
          ),
        ),
      ],
    );
  }
}
