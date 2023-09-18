import 'package:kana_to_kanji/src/core/constants/regexp.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';

class FeedbackViewModel extends BaseViewModel {
  final AppLocalizations l10n;

  FeedbackType? _selectedFeedbackType;

  FeedbackType? get selectedFeedbackType => _selectedFeedbackType;

  final Map<FeedbackFormFields, String> _formData = {
    FeedbackFormFields.email: "",
    FeedbackFormFields.description: "",
    FeedbackFormFields.stepsToReproduce: "",
  };

  bool get isFormSubmitEnabled =>
      (_selectedFeedbackType == FeedbackType.featureRequest &&
          _formData[FeedbackFormFields.description]!.isNotEmpty) ||
          (_selectedFeedbackType == FeedbackType.bug &&
              _formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty);

  bool get isFormAddScreenshotEnabled =>
      _selectedFeedbackType == FeedbackType.bug &&
          _formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty;

  FeedbackViewModel(this.l10n, [this._selectedFeedbackType]);

  void onFeedbackTypePressed(FeedbackType type) {
    _selectedFeedbackType = type;
    notifyListeners();
  }

  void onFormChange(FeedbackFormFields field, String value) {
    _formData.update(field, (_) => value, ifAbsent: () => value);
    notifyListeners();
  }

  String? formValidator(FeedbackFormFields field, String? value) {
    String? validation;

    switch (field) {
      case FeedbackFormFields.email:
        if (value != null && value.isNotEmpty && !emailRegexp.hasMatch(value)) {
          validation = l10n.invalid_email;
        }
        break;
      case FeedbackFormFields.description:
        if (_selectedFeedbackType == FeedbackType.featureRequest &&
            (value == null || value.isEmpty)) {
          validation = l10n.feedback_empty_description;
        }
        break;
      case FeedbackFormFields.stepsToReproduce:
        if (_selectedFeedbackType == FeedbackType.bug &&
            (value == null || value.isEmpty)) {
          validation = l10n.feedback_empty_steps_to_reproduce;
        }
        break;
    }

    return validation;
  }

  Future<void> onFormSubmit() async {
    // TODO Send data to Github
  }
}
