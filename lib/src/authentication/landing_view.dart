import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_config.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:rive/rive.dart";

const Duration _duration = Duration(milliseconds: 400);

class LandingView extends StatefulWidget {
  static const routeName = "/authentication";

  const LandingView({
    super.key,
  });

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late bool _isJpTxtShow;
  late Timer _textTransitionTimer;

  /// Plays with the state of the widget to change the text every 5 seconds.
  void _transitionText() {
    setState(() {
      _isJpTxtShow = !_isJpTxtShow;
    });
  }

  @override
  void initState() {
    super.initState();
    _isJpTxtShow = true;
    _textTransitionTimer = Timer.periodic(
        const Duration(seconds: 5), (timer) => _transitionText());
  }

  @override
  void dispose() {
    super.dispose();
    _textTransitionTimer.cancel();
  }

  final TextStyle _style = const TextStyle(
      // TODO : Change style, it's ugly !
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AppScaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                    width: 300,
                    height: 300,
                    child: RiveAnimation.asset(
                      "assets/animations/kitsune_hot_cup_of_tea.riv",
                      artboard: AppConfig.of(context).environment.name,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: Stack(alignment: Alignment.center, children: [
                    AnimatedPositioned(
                      top: _isJpTxtShow ? 0.0 : 40.0,
                      duration: _duration,
                      child: AnimatedOpacity(
                        opacity: _isJpTxtShow ? 1.0 : 0.0,
                        duration: _duration,
                        child: const Text("誰ですか？"),
                      ),
                    ),
                    AnimatedPositioned(
                      top: _isJpTxtShow ? -40.0 : 0.0,
                      duration: _duration,
                      child: AnimatedOpacity(
                        opacity: _isJpTxtShow ? 0.0 : 1.0,
                        duration: _duration,
                        child: Text(
                          l10n.landing_who_is_it,
                        ),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await GoRouter.of(context).replace(GlossaryView.routeName);
                },
                child: Text(
                  l10n.landing_sign_in,
                  style: _style,
                ),
              )),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await GoRouter.of(context).replace(GlossaryView.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  l10n.landing_getting_started,
                  style: _style,
                ),
              ))
        ],
      ),
    ));
  }
}
