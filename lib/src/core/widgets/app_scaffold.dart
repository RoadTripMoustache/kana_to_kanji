import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/widgets/app_bottom_navigation_bar.dart";

/// Basic Scaffold to avoid boilerplate code in the application.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;

  final Widget body;

  final FloatingActionButton? fab;

  final FloatingActionButtonLocation? fabPosition;

  final bool resizeToAvoidBottomInset;

  final double minimumHorizontalPadding;

  final bool showBottomBar;

  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.fab,
    this.fabPosition,
    this.resizeToAvoidBottomInset = false,
    this.showBottomBar = false,
    this.minimumHorizontalPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    appBar: appBar,
    body: SafeArea(
      left: false,
      right: false,
      minimum: EdgeInsets.symmetric(horizontal: minimumHorizontalPadding),
      child: Stack(children: [body]),
    ),
    bottomNavigationBar: showBottomBar ? const AppBottomNavigationBar() : null,
    floatingActionButton: fab,
    floatingActionButtonLocation: fabPosition,
  );
}
