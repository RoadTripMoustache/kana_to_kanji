import "dart:typed_data";

import "package:feedback/feedback.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:image/image.dart" as image;
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/regexp.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/widgets/app_config.dart";
import "package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart";
import "package:kana_to_kanji/src/feedback/constants/feedback_type.dart";
import "package:kana_to_kanji/src/feedback/service/github_service.dart";
import "package:kana_to_kanji/src/feedback/utils/build_issue_helper.dart";
import "package:kana_to_kanji/src/feedback/widgets/feedback_success_dialog.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

/// Width of the encoded screenshot.
/// We fix this value as depending on user's device we can have a
/// insane amount of pixels
const kScreenshotPortraitWidth = 720;
const kScreenshotLandscapeWidth = 1280;

class FeedbackViewModel extends BaseViewModel {
  final GithubService _githubService;
  final GoRouter router;
  final AppConfig appConfig;
  final AppLocalizations l10n;

  FeedbackType? _selectedFeedbackType;

  /// Which type of feedback was selected by the user.
  FeedbackType? get selectedFeedbackType => _selectedFeedbackType;

  /// Contains all the fields and value from the form
  @visibleForTesting
  final Map<FeedbackFormFields, String> formData = {
    FeedbackFormFields.email: "",
    FeedbackFormFields.description: "",
    FeedbackFormFields.stepsToReproduce: "",
  };

  /// Used to determine if submit/add screenshot should be allowed
  /// When the form have an error, submit or adding a screenshot should not be
  /// allowed
  bool _formOnError = false;

  /// Indicate if the form can be submitted or not.
  /// Depending on the [selectedFeedbackType] the condition changes
  bool get isFormSubmitEnabled =>
      !_formOnError &&
          (_selectedFeedbackType == FeedbackType.featureRequest &&
              formData[FeedbackFormFields.description]!.isNotEmpty) ||
      (_selectedFeedbackType == FeedbackType.bug &&
          formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty);

  /// Indicate if including a screenshot is allowed.
  /// The screenshot are only allowed for [FeedbackType.bug]
  bool get isFormAddScreenshotEnabled =>
      !_formOnError &&
      _selectedFeedbackType == FeedbackType.bug &&
      formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty;

  /// Do not provide [githubService] as it's present for testing purpose only.
  FeedbackViewModel({
    required this.appConfig,
    required this.router,
    required this.l10n,
    FeedbackType? feedbackType,
    GithubService? githubService,
  }) : _selectedFeedbackType = feedbackType,
       _githubService = githubService ?? GithubService();

  void onFeedbackTypePressed(FeedbackType type) {
    _selectedFeedbackType = type;
    notifyListeners();
  }

  /// Start the screenshot process.
  /// Close the feedback dialog and open [BetterFeedback]
  void onIncludeScreenshotPressed(BuildContext context) {
    router.pop();
    BetterFeedback.of(context).show((feedback) async {
      await onFormSubmit(feedback.screenshot);
    });
  }

  /// onChange callback that update the [value] of the specified [field]
  void onFormChange(FeedbackFormFields field, String value) {
    formData.update(field, (_) => value, ifAbsent: () => value);
    notifyListeners();
  }

  /// Validate the current content of a [field].
  /// Depending on [selectedFeedbackType], the [field] will be
  /// validated differently
  String? formValidator(FeedbackFormFields field, String? value) {
    String? validation;

    switch (field) {
      case FeedbackFormFields.email:
        if (value != null && value.isNotEmpty && !emailRegexp.hasMatch(value)) {
          validation = l10n.invalid_email;
        }
      case FeedbackFormFields.description:
        if (_selectedFeedbackType == FeedbackType.featureRequest &&
            (value == null || value.isEmpty)) {
          validation = l10n.feedback_empty_description;
        }
      case FeedbackFormFields.stepsToReproduce:
        if (_selectedFeedbackType == FeedbackType.bug &&
            (value == null || value.isEmpty)) {
          validation = l10n.feedback_empty_steps_to_reproduce;
        }
    }

    _formOnError = validation != null;
    return validation;
  }

  /// Create the Github issue with all the data entered by the user.
  /// If [screenshot] is provided, it will upload the screenshot before creating
  /// the issue.
  Future<void> onFormSubmit([Uint8List? screenshot]) async {
    // Function should not be called, stopping here.
    if (!isFormSubmitEnabled) {
      return;
    }

    bool needToBeClosed = true;
    String? screenshotUrl;
    final labels = [_selectedFeedbackType!.value];

    setBusy(true);
    if (screenshot != null) {
      // No need to close the dialog as [onIncludeScreenshotPressed]
      // already closed it
      needToBeClosed = false;

      // Encode the image then upload it
      final image.Image screenshotImage = image.decodeImage(screenshot)!;
      final Uint8List encodedScreenshot = image.encodePng(
        image.copyResize(
          screenshotImage,
          // Resize differently if we are on landscape or portrait mode
          width:
              screenshotImage.height > screenshotImage.width
                  ? kScreenshotPortraitWidth
                  : kScreenshotLandscapeWidth,
        ),
      );
      screenshotUrl = await _githubService.uploadFileToGithub(
        filePath: DateTime.now().toIso8601String(),
        fileInBytes: encodedScreenshot.toList(growable: false),
      );
    }

    // Create the issue
    await _githubService.createIssue(
      title: buildIssueTitle(_selectedFeedbackType!),
      body: buildIssueBody(appConfig.environment, formData, screenshotUrl),
      labels: labels,
    );
    setBusy(false);

    // Close the dialog if still opened
    if (needToBeClosed) {
      router.pop();
    }

    // Show success dialog and thanks the user
    await locator<DialogService>().showModalBottomSheet(
      isDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), router.pop);
        return const FeedbackSuccessDialog();
      },
    );
  }
}
