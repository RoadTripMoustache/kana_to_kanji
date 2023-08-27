import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';

class SettingsView extends StatelessWidget {
  static const routeName = "/settings";

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
      child: Text("Settings"),
    ));
  }
}
