import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';

class FeedbackScreenshotForm extends StatefulWidget {
  final Future<void> Function(String, {Map<String, dynamic>? extras}) onSubmit;

  final ScrollController? scrollController;

  const FeedbackScreenshotForm(
      {super.key, required this.onSubmit, this.scrollController});

  @override
  State<FeedbackScreenshotForm> createState() => _FeedbackScreenshotFormState();
}

class _FeedbackScreenshotFormState extends State<FeedbackScreenshotForm> {
  final dataKey = GlobalKey();

  String _description = "";

  onChange(String value) {
    _description = value;
  }

  onSubmit() async {
    await widget.onSubmit(_description);
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
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              children: [
                if (widget.scrollController != null)
                  const SizedBox(
                      height: kMinInteractiveDimension,
                      width: kMinInteractiveDimension,
                      child: FeedbackSheetDragHandle()),
                TextFormField(
                    key: dataKey,
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    decoration: InputDecoration(
                        labelText: l10n.feedback_description_optional,
                        hintText: l10n.feedback_report_bug_subtitle),
                    onChanged: onChange,
                    textInputAction: TextInputAction.done),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FilledButton(
                      onPressed: onSubmit,
                      style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      child: Text(
                        l10n.feedback_submit(FeedbackType.bug.name),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
