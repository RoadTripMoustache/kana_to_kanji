import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/build_quiz/build_quiz_view.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view.dart';

final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: BuildQuizView.routeName,
    routes: [
      GoRoute(
          path: BuildQuizView.routeName,
          builder: (_, __) => const BuildQuizView(),
          routes: [
            GoRoute(
                path: QuizView.routeName
                    .substring(BuildQuizView.routeName.length + 1),
                redirect: (_, state) {
                  if (state.extra is! List<Group>) {
                    return "/error";
                  }
                  return null;
                },
                builder: (_, state) => QuizView(
                      groups: state.extra as List<Group>,
                    ))
          ])
    ]);
