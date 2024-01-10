import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/widgets/app_not_found_view.dart';
import 'package:kana_to_kanji/src/glossary/details/kana_details_view.dart';
import 'package:kana_to_kanji/src/glossary/glossary_view.dart';
import 'package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view.dart';
import 'package:kana_to_kanji/src/settings/settings_view.dart';
import 'package:kana_to_kanji/src/splash/splash_view.dart';

const String _initialLocation = SplashView.routeName;

GoRouter buildRouter([GlobalKey<NavigatorState>? key]) => GoRouter(
        navigatorKey: key,
        initialLocation: _initialLocation,
        errorBuilder: (context, state) =>
            AppNotFoundView(uri: state.uri, goBackUrl: _initialLocation),
        routes: [
          GoRoute(
              path: SplashView.routeName,
              builder: (_, __) => const SplashView()),
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
              path: SettingsView.routeName,
              builder: (_, __) => const SettingsView()),
          GoRoute(
              path: GlossaryView.routeName,
              builder: (_, __) => const GlossaryView(),
              routes: [
                GoRoute(
                    path: KanaDetailsView.routeName
                        .substring(GlossaryView.routeName.length + 1),
                    redirect: (_, state) {
                      if (state.extra is! Kana) {
                        return "/error";
                      }
                      return null;
                    },
                    builder: (_, state) =>
                        KanaDetailsView(kana: state.extra as Kana))
              ])
        ]);
