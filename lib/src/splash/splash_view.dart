import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_config.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/splash/splash_view_model.dart";
import "package:rive/rive.dart";
import "package:stacked/stacked.dart";

class SplashView extends StatelessWidget {
  static const routeName = "/splash";

  const SplashView({super.key});

  static const TextStyle _style = TextStyle(
    fontFamily: "MPlusRounded1c",
    fontWeight: FontWeight.w400,
    fontSize: 60.0,
  );

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ViewModelBuilder<SplashViewModel>.nonReactive(
      viewModelBuilder: () => SplashViewModel(GoRouter.of(context)),
      builder:
          (context, _, __) => AppScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: l10n.app_title_kana,
                      children: [
                        TextSpan(
                          text: l10n.app_title_to,
                          style: const TextStyle(color: Color(0xffFF862F)),
                        ),
                        TextSpan(text: l10n.app_title_kanji),
                      ],
                    ),
                    style: _style,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: RiveAnimation.asset(
                        "assets/animations/kitsune_hot_cup_of_tea.riv",
                        artboard: AppConfig.of(context).environment.name,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
