import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/widgets/rounded_linear_progress_indicator.dart";

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double progressBarValue;
  final void Function() onClosePressed;
  final Future<void> Function() onSkipPressed;

  const QuizAppBar({
    required this.progressBarValue,
    required this.onClosePressed,
    required this.onSkipPressed,
    super.key,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: onClosePressed,
      ),
      title: Row(
        children: [
          Expanded(
            child: RoundedLinearProgressIndicator(
              value: progressBarValue,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onSkipPressed,
          child: Text(l10n.quiz_skip_question),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
