import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';

class FeedbackScreenshotForm extends StatefulWidget {
  final Future<void> Function(String, {Map<String, dynamic>? extras}) onSubmit;

  const FeedbackScreenshotForm({super.key, required this.onSubmit});

  @override
  State<FeedbackScreenshotForm> createState() => _FeedbackScreenshotFormState();
}

class _FeedbackScreenshotFormState extends State<FeedbackScreenshotForm> {
  bool _isLoading = false;

  onSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await widget.onSubmit("");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Theme(
        data: isDarkModeEnabled ? AppTheme.dark() : AppTheme.light(),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: FilledButton(
                onPressed: _isLoading ? null : () => onSubmit(context),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                child: _isLoading
                    ? SizedBox.fromSize(
                        size: const Size.square(24.0),
                        child: const CircularProgressIndicator(),
                      )
                    : Text(
                        l10n.feedback_submit(FeedbackType.bug.name),
                      ))),
      ),
    );
  }
}
