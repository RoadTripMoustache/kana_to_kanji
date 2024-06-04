import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class ProfileViewModel extends FutureViewModel {
  final UserRepository _userRepository = locator<UserRepository>();
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();
  final TokenService _tokenService = locator<TokenService>();
  final GoRouter router;

  ProfileViewModel(this.router);

  @override
  Future futureToRun() async {}

  /// Get the current logged in user display name.
  String getUserName() {
    if (_userRepository.self == null) {
      return "";
    } else {
      return _userRepository.self!.displayName;
    }
  }

  /// Get the current logged in user account creation date.
  /// returns: String - The date formatted with `MMMM yyyy`. (ex: "June 2023")
  String getUserCreationDate() {
    if (_userRepository.self == null) {
      return "";
    } else {
      final dateTime = DateTime.parse(_userRepository.self!.createdAt);

      return DateFormat("MMMM yyyy", _settingsRepository.locale?.languageCode)
          .format(dateTime);
    }
  }

  bool isAnonymousUser() => _tokenService.isAnonymous;
}
