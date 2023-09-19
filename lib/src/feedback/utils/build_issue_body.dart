import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/locator.dart';

String buildIssueTitle(FeedbackType feedbackType) {
  return "${feedbackType == FeedbackType.bug ? "Bug" : "Feature request"} from a user";
}

String buildIssueBody(
    AppConfig appConfig, Map<FeedbackFormFields, String> formData,
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
      "### Other informations\n\n- **Device**: ${infoService.devicePlatformName}\n"
      "- **Platform version**: ${infoService.platformVersion}\n"
      "- **Application version**: ${infoService.appFullVersion}\n"
      "- **Channel**: ${appConfig.environment.name}\n\n";

  return body;
}
