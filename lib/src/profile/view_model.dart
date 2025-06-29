import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/models/user/user.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/profile/update_avatar/view.dart";
import "package:kana_to_kanji/src/settings/settings_view.dart";
import "package:stacked/stacked.dart";

class ProfileViewModel extends ReactiveViewModel {
  final UserRepository _repository = locator<UserRepository>();
  final GoRouter router;

  User get user => _repository.self!;

  String get displayName =>
      user.displayName.isEmpty ? "Anonymous" : user.displayName;

  DateTime get learningSince => DateTime.parse(user.createdAt);

  int get streakCount => user.streakCount;

  // TODO: Update once learning system is implemented
  int get wordsLearned => 0;

  ProfileViewModel(this.router);

  @override
  List<ListenableServiceMixin> get listenableServices => [_repository];

  void goToSettings() => router.push(SettingsView.routeName);

  void updateAvatar() => router.push(UpdateAvatarView.routeName);
}
