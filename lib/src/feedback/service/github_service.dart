import 'dart:convert';

import 'package:github/github.dart';
import 'package:kana_to_kanji/src/core/constants/app_configuration.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:logger/logger.dart';

class GithubService {
  final Logger _logger = locator<Logger>();

  final InfoService _infoService = locator<InfoService>();

  final CommitUser _commitUser =
      CommitUser(AppConfiguration.githubUser, AppConfiguration.githubUserEmail);

  late GitHub _github;

  GithubService() {
    _github =
        GitHub(auth: Authentication.withToken(AppConfiguration.githubToken));
  }

  /// Upload a file to the ApplETS/Notre-Dame-Bug-report repository
  void uploadFileToGithub({required String filePath, required File file}) {
    _github.repositories
        .createFile(
            RepositorySlug.full(AppConfiguration.githubFeedbackRepoSlug),
            CreateFile(
                path: filePath,
                content: base64Encode(file.readAsBytesSync()),
                message: DateTime.now().toString(),
                committer: _commitUser,
                branch: 'main'))
        .catchError((error) {
      // ignore: avoid_dynamic_calls
      _logger.e("uploadFileToGithub error: ${error.message}");
    });
  }

  /// Create Github issue into the Notre-Dame repository with the labels bugs and the platform used.
  /// The bug report will contain a file, a description [feedbackText] and also some information about the
  /// application/device.
  Future<Issue> createGithubIssue(
      {required String feedbackText,
      required String fileName,
      required FeedbackType feedbackType,
      String? email}) async {
    return _github.issues
        .create(
            RepositorySlug.full(AppConfiguration.githubRepoSlug),
            IssueRequest(
                title: '${feedbackType == FeedbackType.bug ? "Bug": "Feature request"} from ${_infoService.appName} ',
                body: " **Describe the issue** \n"
                    "```$feedbackText```\n\n"
                    "**Screenshot** \n"
                    "![screenshot](https://github.com/${AppConfiguration.githubFeedbackRepoSlug}/blob/main/$fileName?raw=true)\n\n"
                    "${await _internalInfoService.getDeviceInfoForErrorReporting()}"
                    "- **Email:** ${email ?? 'Not provided'} \n",
                labels: [
                  feedbackType.name,
                  'platform: ${Platform.operatingSystem}'
                ]))
        .catchError((error) {
      // ignore: avoid_dynamic_calls
      _logger.e("createGithubIssue error: ${error.message}");
    });
  }
}
