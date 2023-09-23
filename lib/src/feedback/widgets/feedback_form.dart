import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';

class FeedbackForm extends StatefulWidget {
  final FeedbackType feedbackType;

  final Function(FeedbackFormFields field, String value) onChange;

  final String? Function(FeedbackFormFields field, String? value) validator;

  final bool isSubmitEnabled;

  final bool allowScreenshot;

  final VoidCallback? onScreenshotButtonPressed;

  final Future Function([Uint8List? screenshot]) onSubmit;

  const FeedbackForm(
      {super.key,
      required this.feedbackType,
      required this.onChange,
      required this.validator,
      required this.onSubmit,
      this.isSubmitEnabled = false,
      this.allowScreenshot = false,
      this.onScreenshotButtonPressed});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  bool _isLoading = false;

  Future<void> onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onSubmit();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    const EdgeInsetsGeometry padding = EdgeInsets.only(top: 12.0);
    List<Widget> extraWidgets = (widget.feedbackType == FeedbackType.bug)
        ? [
            Padding(
              padding: padding,
              child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  scrollPadding: EdgeInsets.only(
                      bottom:
                          Theme.of(context).textTheme.bodyMedium!.fontSize! *
                              8),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) => widget.onChange(
                      FeedbackFormFields.stepsToReproduce, value),
                  validator: (String? value) => widget.validator(
                      FeedbackFormFields.stepsToReproduce, value),
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
                  onPressed:
                      widget.allowScreenshot && !_isLoading ? widget.onScreenshotButtonPressed : null,
                  child: Text(l10n.feedback_include_screenshot)),
            )
          ]
        : [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String value) =>
                    widget.onChange(FeedbackFormFields.email, value),
                validator: (String? value) =>
                    widget.validator(FeedbackFormFields.email, value),
                decoration: InputDecoration(
                    labelText: l10n.email_optional,
                    helperText: l10n.feedback_email_helper),
                textInputAction: TextInputAction.next),
            Padding(
              padding: padding,
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  maxLength: 1000,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  scrollPadding: EdgeInsets.only(
                      bottom:
                          Theme.of(context).textTheme.bodyMedium!.fontSize! *
                              8),
                  decoration: InputDecoration(
                      labelText:
                          widget.feedbackType == FeedbackType.featureRequest
                              ? l10n.feedback_description
                              : l10n.feedback_description_optional,
                      hintText:
                          widget.feedbackType == FeedbackType.featureRequest
                              ? l10n.feedback_request_feature_subtitle
                              : l10n.feedback_report_bug_subtitle),
                  onChanged: (String value) =>
                      widget.onChange(FeedbackFormFields.description, value),
                  validator: (String? value) =>
                      widget.validator(FeedbackFormFields.description, value),
                  textInputAction:
                      widget.feedbackType == FeedbackType.featureRequest
                          ? TextInputAction.done
                          : TextInputAction.next),
            ),
            ...extraWidgets,
            FilledButton(
                onPressed: widget.isSubmitEnabled && !_isLoading
                    ? onSubmit
                    : null,
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                child: _isLoading
                    ? SizedBox.fromSize(
                        size: const Size.square(24.0),
                        child: const CircularProgressIndicator(),
                      )
                    : Text(
                        l10n.feedback_submit(widget.feedbackType.name),
                      ))
          ],
        ),
      ),
    );
  }
}
