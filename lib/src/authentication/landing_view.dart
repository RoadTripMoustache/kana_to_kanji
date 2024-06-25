import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view_model.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view.dart";
import "package:kana_to_kanji/src/core/widgets/app_config.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/app_spacer.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:rive/rive.dart";
import "package:stacked/stacked.dart";

class LandingView extends StatelessWidget {
  static const routeName = "/authentication";

  const LandingView({
    super.key,
  });

  static const TextStyle _style = TextStyle(
      // TODO : Change style, it's ugly !
      fontWeight: FontWeight.w500,
      // color: Colors.black,
      fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ViewModelBuilder<LandingViewModel>.reactive(
        viewModelBuilder: () =>
            LandingViewModel(locale: Localizations.localeOf(context)),
        builder: (context, viewModel, _) => AppScaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                        width: 400,
                        child: RiveAnimation.asset(
                          "assets/animations/landing.riv",
                          artboard: AppConfig.of(context).environment.name,
                          onInit: viewModel.onRiveInit,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await GoRouter.of(context)
                                        .push(SignInView.routeName);
                                  },
                                  child: Text(
                                    l10n.landing_sign_in,
                                    style: _style,
                                  ),
                                ),
                              ),
                              AppSpacer.p8(),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await GoRouter.of(context)
                                        .replace(GlossaryView.routeName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Text(
                                    l10n.landing_getting_started,
                                    style: _style.copyWith(color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
