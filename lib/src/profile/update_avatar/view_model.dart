import "package:avatar_maker/avatar_maker.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class UpdateAvatarViewModel extends BaseViewModel {
  final UserRepository _repository = locator<UserRepository>();
  late final AvatarMakerController makerController;
  final GoRouter router;

  String? get avatarUrl => _repository.self?.avatar;

  String _avatar = "";

  String get avatar => _avatar;

  UpdateAvatarViewModel(this.router) {
    makerController = NonPersistentAvatarMakerController.fromSvg(
      svg: _repository.self!.avatar ?? "",
    )..addListener(_onAvatarChanged);
    _avatar = makerController.displayedAvatarSVG;
  }

  void _onAvatarChanged() {
    _avatar = makerController.displayedAvatarSVG;
    notifyListeners();
  }

  Future<void> save() async {
    setBusy(true);
    if (await _repository.updateSelf(
      _repository.self!.copyWith(avatar: _avatar),
    )) {
      if (router.canPop()) {
        router.pop();
      }
    }
    setBusy(false);
    // TODO handle save failed case
  }

  @override
  void dispose() {
    makerController.dispose();
    super.dispose();
  }
}
