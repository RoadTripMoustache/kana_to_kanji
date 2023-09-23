import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/constants/regexp.dart';
import 'package:kana_to_kanji/src/core/services/dialog_service.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';
import 'package:kana_to_kanji/src/feedback/service/github_service.dart';
import 'package:kana_to_kanji/src/feedback/utils/build_issue_body.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_success_dialog.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:image/image.dart' as image;

const _kScreenshotWidth = 300;

class FeedbackViewModel extends BaseViewModel {
  final GithubService _githubService;
  final GoRouter router;
  final AppConfig appConfig;
  final AppLocalizations l10n;

  FeedbackType? _selectedFeedbackType;

  FeedbackType? get selectedFeedbackType => _selectedFeedbackType;

  final Map<FeedbackFormFields, String> _formData = {
    FeedbackFormFields.email: "",
    FeedbackFormFields.description: "",
    FeedbackFormFields.stepsToReproduce: "",
  };

  bool _formOnError = false;

  bool get isFormSubmitEnabled =>
      !_formOnError &&
          (_selectedFeedbackType == FeedbackType.featureRequest &&
              _formData[FeedbackFormFields.description]!.isNotEmpty) ||
      (_selectedFeedbackType == FeedbackType.bug &&
          _formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty);

  bool get isFormAddScreenshotEnabled =>
      !_formOnError &&
      _selectedFeedbackType == FeedbackType.bug &&
      _formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty;

  /// [githubService] is present for testing purpose only.
  FeedbackViewModel(
      {required this.appConfig,
      required this.router,
      required this.l10n,
      FeedbackType? feedbackType,
      GithubService? githubService})
      : _selectedFeedbackType = feedbackType,
        _githubService = githubService ?? GithubService();

  void onFeedbackTypePressed(FeedbackType type) {
    _selectedFeedbackType = type;
    notifyListeners();
  }

  void onIncludeScreenshotPressed(BuildContext context) {
    router.pop();
    BetterFeedback.of(context).show((feedback) async {
      await onFormSubmit(feedback.screenshot);
    });
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

    _formOnError = validation != null;
    return validation;
  }

  Future<void> onFormSubmit([Uint8List? screenshot]) async {
    bool needToBeClosed = true;
    final labels = [
      _selectedFeedbackType!.value,
    ];

    setBusy(true);
    if (screenshot != null) {
      needToBeClosed = false;
      final Uint8List encodedScreenshot = image.encodePng(image.copyResize(
          image.decodeImage(screenshot)!,
          width: _kScreenshotWidth));
      final screenshotUrl = await _githubService.uploadFileToGithub(
          filePath: DateTime.now().toIso8601String(),
          fileInBytes: encodedScreenshot.toList(growable: false));

      await _githubService.createIssue(
          title: buildIssueTitle(_selectedFeedbackType!),
          body: buildIssueBody(appConfig.environment, _formData, screenshotUrl),
          labels: labels);
    } else {
      await _githubService.createIssue(
          title: buildIssueTitle(_selectedFeedbackType!),
          body: buildIssueBody(appConfig.environment, _formData),
          labels: labels);
    }
    setBusy(false);

    // Close the dialog if still opened
    if (needToBeClosed) {
      router.pop();
    }

    // Show success and thank the user
    locator<DialogService>().showModalBottomSheet(
        isDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 3), () => context.pop());
          return const FeedbackSuccessDialog();
        });
  }
}
