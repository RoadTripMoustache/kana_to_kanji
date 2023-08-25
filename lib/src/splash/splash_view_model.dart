import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends FutureViewModel {
  final GoRouter goRouter;

  SplashViewModel(this.goRouter);

  /// Here we check that everything is ready before moving to the main screen
  @override
  Future futureToRun() async {
    await locator.allReady();

    // Move to main screen
    goRouter.replace(PrepareQuizView.routeName);
  }
}
