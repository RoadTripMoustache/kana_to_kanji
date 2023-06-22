import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';

class BuildQuizView extends StatelessWidget {
  static const routeName = "/quiz";
  const BuildQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return const AppScaffold(
        body: Center(
          child: Text("Build quiz view"),
    ));
  }
}
