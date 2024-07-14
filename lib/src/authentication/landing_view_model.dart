import "dart:ui";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:rive/rive.dart";
import "package:stacked/stacked.dart";

class LandingViewModel extends BaseViewModel {
  /// Locale used to determine the language of the animation
  final Locale locale;
  final UserRepository _userRepository = locator<UserRepository>();

  LandingViewModel({required this.locale});

  /// Initialize the rive animation with the correct language.
  void onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, "Default");

    artboard.addController(controller!);

    // Update the language code
    controller
        .getNumberInput("language_code")
        ?.change(_determineLanguageCodeForAnimation());
  }

  /// Determine which language to use for the animation.
  /// By default, english will be used.
  double _determineLanguageCodeForAnimation() {
    switch (locale.languageCode) {
      case "fr":
        return 1;
      case "en":
        return 0;
    }
    return 0;
  }

  /// Sign the current user anonymously and redirect the user to the glossary
  /// if everything goes well.
  Future<void> getStarted(GoRouter router) async {
    if (await _userRepository.authenticate(AuthenticationMethod.anonymous)) {
      await router.replace(GlossaryView.routeName);
    }
  }
}
