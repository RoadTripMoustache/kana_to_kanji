import 'package:flutter/material.dart';

/// Basic Scaffold to avoid boilerplate code in the application.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;

  final Widget body;

  final FloatingActionButton? fab;

  final FloatingActionButtonLocation? fabPosition;

  final bool resizeToAvoidBottomInset;

  const AppScaffold(
      {super.key,
      this.appBar,
      required this.body,
      this.fab,
      this.fabPosition,
      this.resizeToAvoidBottomInset = false});

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      body: SafeArea(
        top: false,
        child: Stack(children: [
          body,
        ]),
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: fabPosition);
}
