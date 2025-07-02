import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/stat_card.dart";
import "package:kana_to_kanji/src/profile/view_model.dart";
import "package:kana_to_kanji/src/profile/widgets/avatar.dart";
import "package:stacked/stacked.dart";

class ProfileView extends StatelessWidget {
  static const String routeName = "/profile";

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(GoRouter.of(context)),
      builder:
          (context, viewModel, child) => AppScaffold(
            showBottomBar: true,
            appBar: AppBar(
              actions: [
                RTMIconButton(
                  onPressed: viewModel.goToSettings,
                  icon: Icon(Icons.settings_rounded),
                ),
              ],
            ),
            body: Column(
              spacing: 12,
              children: [
                if (viewModel.user.avatar == null)
                  RTMSpinner()
                else
                  Avatar(
                    svg: viewModel.user.avatar!,
                    onTap: viewModel.updateAvatar,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          viewModel.displayName,
                          style: textTheme.headlineSmall,
                        ),
                        Text(
                          l10n.profile_learning_since(viewModel.learningSince),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreakStatCard(count: viewModel.streakCount),
                    WordsStatCard(count: viewModel.wordsLearned),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
