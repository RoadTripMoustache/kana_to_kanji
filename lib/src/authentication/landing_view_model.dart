import "dart:ui";
import "package:rive/rive.dart";
import "package:stacked/stacked.dart";

class LandingViewModel extends BaseViewModel {
  /// Locale used to determine the language of the animation
  final Locale locale;

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
}
