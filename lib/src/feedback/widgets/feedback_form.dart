import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';

class FeedbackForm extends StatelessWidget {
  final FeedbackType feedbackType;

  final Function(FeedbackFormFields field, String value) onChange;

  final String? Function(FeedbackFormFields field, String? value) validator;

  final bool isSubmitEnabled;

  final bool allowScreenshot;

  final Future Function([Uint8List? screenshot]) onSubmit;

  const FeedbackForm({
    super.key,
    required this.feedbackType,
    required this.onChange,
    required this.validator,
    required this.onSubmit,
    this.isSubmitEnabled = false,
    this.allowScreenshot = false,
  });

  void _onScreenshotSubmit(UserFeedback feedback, BuildContext context) {
    onSubmit(feedback.screenshot);
    BetterFeedback.of(context).hide();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    const EdgeInsetsGeometry padding = EdgeInsets.only(top: 12.0);

    List<Widget> extraWidgets = (feedbackType == FeedbackType.bug)
        ? [
            Padding(
              padding: padding,
              child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) =>
                      onChange(FeedbackFormFields.stepsToReproduce, value),
                  validator: (String? value) =>
                      validator(FeedbackFormFields.stepsToReproduce, value),
                  decoration: InputDecoration(
                    labelText: l10n.feedback_bug_steps,
                  ),
                  textInputAction: TextInputAction.done),
            ),
            Padding(
              padding: padding,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: allowScreenshot
                      ? () {
                          // Close the dialog
                          context.pop();
                          BetterFeedback.of(context).show((feedback) =>
                              _onScreenshotSubmit(feedback, context));
                        }
                      : null,
                  child: Text(l10n.feedback_include_screenshot)),
            )
          ]
        : [];

    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (String value) =>
                  onChange(FeedbackFormFields.email, value),
              validator: (String? value) =>
                  validator(FeedbackFormFields.email, value),
              decoration: InputDecoration(
                  labelText: l10n.email_optional,
                  helperText: l10n.feedback_email_helper),
              textInputAction: TextInputAction.next),
          Padding(
            padding: padding,
            child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.text,
                maxLines: 4,
                maxLength: 1000,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    labelText: feedbackType == FeedbackType.featureRequest
                        ? l10n.feedback_description
                        : l10n.feedback_description_optional,
                    hintText: feedbackType == FeedbackType.featureRequest
                        ? l10n.feedback_request_feature_subtitle
                        : l10n.feedback_report_bug_subtitle),
                onChanged: (String value) =>
                    onChange(FeedbackFormFields.description, value),
                validator: (String? value) =>
                    validator(FeedbackFormFields.description, value),
                textInputAction: feedbackType == FeedbackType.featureRequest
                    ? TextInputAction.done
                    : TextInputAction.next),
          ),
          ...extraWidgets,
          FilledButton(
              onPressed: isSubmitEnabled ? onSubmit : null,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(40)),
              child: Text(
                l10n.feedback_submit(feedbackType.name),
              ))
        ],
      ),
    );
  }
}
