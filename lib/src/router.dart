import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/quiz/build_quiz_view.dart';

final router = GoRouter(initialLocation: BuildQuizView.routeName, routes: [
  GoRoute(
      path: BuildQuizView.routeName, builder: (_, __) => const BuildQuizView()),
]);
