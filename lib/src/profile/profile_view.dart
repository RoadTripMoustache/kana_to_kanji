import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/profile/profile_view_model.dart";
import "package:stacked/stacked.dart";

class ProfileView extends StatelessWidget {
  static const routeName = "/profile";

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(GoRouter.of(context)),
        builder: (context, viewModel, child) => const AppScaffold(
          resizeToAvoidBottomInset: true,
          showBottomBar: true,
          body: Text("todo"),
        ),
      );
}
