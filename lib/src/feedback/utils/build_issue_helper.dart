import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/locator.dart';

/// Build the title of a Github issue based on the [feedbackType].
/// The title isn't localized, it's written in english.
String buildIssueTitle(FeedbackType feedbackType) {
  return "${feedbackType == FeedbackType.bug ? "Bug" : "Feature request"} from a user";
}

/// Build the body of a Github issue. The text isn't localized, it's written in english.
/// The text will include the description, email and steps to reproduced based on
/// what is available on [formData].
/// Using the [InfoService], device and application information like application version,
/// device model, device OS will be added. Will also be added the [environment] of the application.
/// If [screenshotUrl] is provided, a screenshot section will be added.
String buildIssueBody(
    Environment environment, Map<FeedbackFormFields, String> formData,
    [String? screenshotUrl]) {
  final InfoService infoService = locator<InfoService>();
  String body = "";

  if (formData.containsKey(FeedbackFormFields.description) &&
      formData[FeedbackFormFields.description]!.isNotEmpty) {
    body +=
        "### Description\n\n${formData[FeedbackFormFields.description]}\n\n";
  }

  if (formData.containsKey(FeedbackFormFields.stepsToReproduce) &&
      formData[FeedbackFormFields.stepsToReproduce]!.isNotEmpty) {
    body +=
        "### Steps to reproduce\n\n${formData[FeedbackFormFields.stepsToReproduce]}\n\n";
  }

  if (screenshotUrl != null) {
    body += "### Screenshot\n\n"
        "![screenshot]($screenshotUrl)\n\n";
  }

  if (formData.containsKey(FeedbackFormFields.email) &&
      formData[FeedbackFormFields.email]!.isNotEmpty) {
    body +=
        "### User information\n\nEmail: ${formData[FeedbackFormFields.email]}\n\n";
  }

  /// Add device and general information
  body +=
      "### Other information\n\n- **Device**: ${infoService.devicePlatformName}\n"
      "- **Platform version**: ${infoService.platformVersion}\n"
      "- **Application version**: ${infoService.appFullVersion}\n"
      "- **Channel**: ${environment.name}\n\n";

  return body;
}
