import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/settings/settings_view.dart";

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GoRouter router;

  const ProfileAppBar({
    required this.router,
    super.key,
  });

  @override
  PreferredSizeWidget build(BuildContext context) => AppBar(
        actions: [
          IconButton(
              onPressed: onSettingsTapped,
              icon: const Icon(Icons.settings_rounded)),
        ],
      );

  Future<void> onSettingsTapped() async {
    await router.push(SettingsView.routeName);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
