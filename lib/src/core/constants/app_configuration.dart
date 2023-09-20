import 'package:envied/envied.dart';

part 'app_configuration.g.dart';

@Envied()
abstract class AppConfiguration {
  @EnviedField(varName: "API_URL")
  static const String apiUrl = _AppConfiguration.apiUrl;

  @EnviedField(varName: "ENABLE_CRASHLYTICS", defaultValue: true)
  static const bool enableCrashlytics = _AppConfiguration.enableCrashlytics;

  /// Configuration for Github service
  @EnviedField(varName: "GITHUB_REPOSITORY_SLUG")
  static const String githubRepoSlug = _AppConfiguration.githubRepoSlug;
  @EnviedField(varName: "GITHUB_FEEDBACK_REPOSITORY_SLUG")
  static const String githubFeedbackRepoSlug = _AppConfiguration.githubFeedbackRepoSlug;
  @EnviedField(varName: "GITHUB_USER", defaultValue: "github-actions[bot]")
  static const String githubUser = _AppConfiguration.githubUser;
  @EnviedField(varName: "GITHUB_USER_EMAIL", defaultValue: "github-actions[bot]@users.noreply.github.com")
  static const String githubUserEmail = _AppConfiguration.githubUserEmail;
  @EnviedField(varName: "GITHUB_TOKEN", obfuscate: true)
  static final String githubToken = _AppConfiguration.githubToken;
}
