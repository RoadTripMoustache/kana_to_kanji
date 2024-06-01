import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/models/app_navigation_destination.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/practice/quiz/practice_view.dart";
import "package:kana_to_kanji/src/profile/profile_view.dart";

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final router = GoRouter.of(context);

    final tabs = _buildDestinations(l10n);
    final currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final selectedIndex =
        tabs.indexWhere((t) => currentRoute.startsWith(t.location));

    return NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (index) => router.go(tabs[index].location),
        destinations:
            tabs.map((e) => e.navigationDestination).toList(growable: false));
  }

  List<AppNavigationDestination> _buildDestinations(AppLocalizations l10n) => [
        // AppNavigationDestination(
        //     icon: const Icon(Icons.home_outlined),
        //     selectedIcon: const Icon(Icons.home_rounded),
        //     label: l10n.app_bottom_bar_home,
        //     location: "/home"),
        // AppNavigationDestination(
        //     icon: const Icon(Icons.school_outlined),
        //     selectedIcon: const Icon(Icons.school_rounded),
        //     label: l10n.app_bottom_bar_lesson,
        //     location: "/lesson"),
        AppNavigationDestination(
            icon: const Icon(Icons.psychology_outlined),
            selectedIcon: const Icon(Icons.psychology_rounded),
            label: l10n.app_bottom_bar_practice,
            location: PracticeView.routeName),
        AppNavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: l10n.app_bottom_bar_glossary,
            location: GlossaryView.routeName),
        AppNavigationDestination(
            icon: const Icon(Icons.face_outlined),
            selectedIcon: const Icon(Icons.face_rounded),
            label: l10n.app_bottom_bar_profile,
            location: ProfileView.routeName)
      ];
}
