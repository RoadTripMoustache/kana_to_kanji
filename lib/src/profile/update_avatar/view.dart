import "package:avatar_maker/avatar_maker.dart";
import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/profile/update_avatar/view_model.dart";
import "package:kana_to_kanji/src/profile/view.dart";
import "package:kana_to_kanji/src/profile/widgets/avatar.dart";
import "package:stacked/stacked.dart";

class UpdateAvatarView extends StatelessWidget {
  static const String routeName = "${ProfileView.routeName}/avatarUpdate";

  const UpdateAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ViewModelBuilder<UpdateAvatarViewModel>.reactive(
      viewModelBuilder: () => UpdateAvatarViewModel(GoRouter.of(context)),
      builder:
          (context, viewModel, child) => AppScaffold(
            appBar: AppBar(
              leading: RTMIconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => context.pop(),
              ),
              actions: [
                RTMTextButton(
                  onPressed: viewModel.save,
                  child: Text(
                    l10n.profile_update_avatar.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(child: Avatar(svg: viewModel.avatar)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewModel.isBusy && context.mounted)
                        RTMSpinner()
                      else
                        AvatarMakerCustomizer(
                          controller: viewModel.makerController,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
