import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class SplashViewModel extends FutureViewModel {
  final GoRouter goRouter;

  final UserRepository _userRepository = locator<UserRepository>();

  SplashViewModel(this.goRouter);

  /// Here we check that everything is ready before moving to the main screen
  @override
  Future futureToRun() async {
    await Future.wait([
      locator.allReady(),
      Future.delayed(
        const Duration(seconds: 1),
      ), // Wait 1s to have the time to load the animation
    ]);

    // Move to main screen
    await goRouter.replace(
      await _userRepository.silentSignIn()
          ? GlossaryView.routeName
          : LandingView.routeName,
    );
  }
}
