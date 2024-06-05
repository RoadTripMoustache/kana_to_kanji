import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class SplashViewModel extends FutureViewModel {
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

    // Move to main screen
    await goRouter.replace(LandingView.routeName);
  }
}
