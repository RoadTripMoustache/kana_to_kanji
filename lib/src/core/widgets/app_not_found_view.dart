import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";

class AppNotFoundView extends StatelessWidget {
  final Uri uri;

  final String goBackUrl;

  const AppNotFoundView(
      {required this.uri, required this.goBackUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.page_not_found(uri.path)),
            ElevatedButton(
                onPressed: () => context.go(goBackUrl),
                child: Text(l10n.go_home_button))
          ],
        ),
      ),
    );
  }
}
