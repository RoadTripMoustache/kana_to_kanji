import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view.dart';
import 'package:kana_to_kanji/src/settings/settings_view.dart';
import 'package:kana_to_kanji/src/splash/splash_view.dart';

final router = GoRouter(initialLocation: SplashView.routeName, routes: [
  GoRoute(path: SplashView.routeName, builder: (_, __) => const SplashView()),
  GoRoute(
      path: PrepareQuizView.routeName,
      builder: (_, __) => const PrepareQuizView(),
      routes: [
        GoRoute(
            path: QuizView.routeName
                .substring(PrepareQuizView.routeName.length + 1),
            redirect: (_, state) {
              if (state.extra is! List<Group>) {
                return "/error";
              }
              return null;
            },
            builder: (_, state) => QuizView(
                  groups: state.extra as List<Group>,
                )),
        GoRoute(
            path: QuizConclusionView.routeName
                .substring(PrepareQuizView.routeName.length + 1),
            redirect: (_, state) {
              if (state.extra is! List<Question>) {
                return "/error";
              }
              return null;
            },
            // +1 remove the /
            builder: (_, state) => QuizConclusionView(
                  questions: state.extra as List<Question>,
                ))
      ]),
  GoRoute(
      path: SettingsView.routeName, builder: (_, __) => const SettingsView())
]);
