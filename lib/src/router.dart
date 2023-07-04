import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/build_quiz/build_quiz_view.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view.dart';

final router = GoRouter(initialLocation: BuildQuizView.routeName, routes: [
  GoRoute(
      path: BuildQuizView.routeName, builder: (_, __) => const BuildQuizView()),
  GoRoute(
      path: QuizView.routeName,
      redirect: (_, state) {
        if (state.extra is! List<Group>) {
          return "/error";
        }
        return null;
      },
      builder: (_, state) => QuizView(
            groups: state.extra as List<Group>,
          ))
]);
