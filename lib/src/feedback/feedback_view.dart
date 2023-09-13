import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/feedback_view_model.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_form.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_type_selection.dart';
import 'package:stacked/stacked.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<FeedbackViewModel>.reactive(
        viewModelBuilder: () => FeedbackViewModel(AppLocalizations.of(context)),
        builder:
            (BuildContext context, FeedbackViewModel viewModel, Widget? child) {
          Widget content =
              FeedbackTypeSelection(onPressed: viewModel.onFeedbackTypePressed);

          if (viewModel.selectedFeedbackType != null) {
            content = FeedbackForm(
              feedbackType: viewModel.selectedFeedbackType!,
              onSubmit: viewModel.onFormSubmit,
              onChange: viewModel.onFormChange,
              validator: viewModel.formValidator,
              isSubmitEnabled: viewModel.isFormSubmitEnabled,
            );
          }

          return SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: content),
          );
        },
      );
}
