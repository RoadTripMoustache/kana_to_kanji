import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:github/github.dart';
import 'package:kana_to_kanji/src/core/constants/app_configuration.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:logger/logger.dart';

class GithubService {
  final Logger _logger = locator<Logger>();

  final CommitUser _commitUser =
      CommitUser(AppConfiguration.githubUser, AppConfiguration.githubUserEmail);

  late GitHub _github;

  GithubService() {
    _github =
        GitHub(auth: Authentication.withToken(AppConfiguration.githubToken));
  }

  /// Upload a file to the report repository.
  /// Return the HTML url of the file to access the file raw
  Future<String> uploadFileToGithub(
      {required String filePath, required List<int> fileInBytes}) async {
    final content = await _github.repositories
        .createFile(
            RepositorySlug.full(AppConfiguration.githubFeedbackRepoSlug),
            CreateFile(
                path: filePath,
                content: base64Encode(fileInBytes),
                message: DateTime.now().toString(),
                committer: _commitUser,
                branch: 'main'))
        .catchError((error) {
      _logger.e("uploadFileToGithub error: ${error.message}");
      throw error;
    });

    return "${content.content!.htmlUrl}?raw=true";
  }

  /// Create a [Issue] on the [AppConfiguration.githubRepoSlug].
  /// The issue created will have two(2) more labels: 'platform: {platform}' and 'need triage'
  Future<Issue?> createIssue(
      {String? title, String? body, List<String> labels = const []}) async {
    final IssueRequest issueToCreate = IssueRequest();
    issueToCreate.title = title ?? "Issue reported by a user";

    issueToCreate.body = body;

    issueToCreate.labels = [
      ...labels,
      'platform: ${kIsWeb ? "web" : defaultTargetPlatform.name}',
      'need triage'
    ];

    try {
      return await _github.issues.create(
          RepositorySlug.full(AppConfiguration.githubRepoSlug), issueToCreate);
    } on GitHubError catch (error) {
      _logger.e("createGithubIssue error: ${error.message}");
      return null;
    }
  }
}
