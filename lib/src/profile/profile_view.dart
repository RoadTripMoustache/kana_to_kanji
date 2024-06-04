import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:fluttermoji/fluttermoji.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/stat_card.dart";
import "package:kana_to_kanji/src/profile/profile_view_model.dart";
import "package:kana_to_kanji/src/profile/widgets/link_account_banner.dart";
import "package:kana_to_kanji/src/profile/widgets/profile_app_bar.dart";
import "package:stacked/stacked.dart";

class ProfileView extends StatelessWidget {
  static const routeName = "/profile";

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(router),
      builder: (context, viewModel, child) => AppScaffold(
        appBar: ProfileAppBar(router: router),
        resizeToAvoidBottomInset: true,
        showBottomBar: true,
        body: SafeArea(
          child: SizedBox(
            // set the height property to take the screen width
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                if (viewModel.isAnonymousUser()) const LinkAccountBanner(),
                FluttermojiCircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(viewModel.getUserName(),
                      style: const TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Text(
                      l10n.learningSince(viewModel.getUserCreationDate()),
                      style: const TextStyle(fontSize: 18.0)),
                ),
                Row(
                  children: [
                    StatCard.streak(isSmall: false, days: 0, l10n: l10n),
                    // TODO: A remplacer
                    StatCard.words(isSmall: false, words: 0, l10n: l10n),
                    // TODO: A remplacer
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
