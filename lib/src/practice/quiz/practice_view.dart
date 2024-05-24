import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/practice/quiz/practice_view_model.dart";
import "package:stacked/stacked.dart";

class PracticeView extends StatelessWidget {
  static const routeName = "/practice";

  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<PracticeViewModel>.reactive(
      viewModelBuilder: () => PracticeViewModel(GoRouter.of(context)),
      builder: (context, viewModel, child) => AppScaffold(
        resizeToAvoidBottomInset: true,
        showBottomBar: true,
        body: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {},
            child: Text(l10n.practice_quiz_practice_button),
          ),
        ),
      ),
    );
  }
}
