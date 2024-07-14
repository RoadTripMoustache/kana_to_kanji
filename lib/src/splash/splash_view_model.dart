import "package:firebase_auth/firebase_auth.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/services/dataloader_service.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class SplashViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final TokenService _tokenService = locator<TokenService>();
  final DataloaderService _dataloaderService = locator<DataloaderService>();
  final GoRouter goRouter;

  SplashViewModel(this.goRouter);

  /// Here we check that everything is ready before moving to the main screen
  @override
  Future futureToRun() async {
    await Future.wait([
      locator.allReady(),
      Future.delayed(const Duration(
          seconds: 1)) // Wait 1s to have the time to load the animation
    ]);

    final User? user = await _authService.getCurrentUser();

    if (user != null) {
      _tokenService.userCredential = user;

      await _dataloaderService.loadStaticData();

      // Move to main app screen
      await goRouter.replace(GlossaryView.routeName);
    } else {
      // Move to the landing screen
      await goRouter.replace(LandingView.routeName);
    }
  }
}
