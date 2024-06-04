import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/create/create_account_view.dart";

class LinkAccountBanner extends StatelessWidget {
  const LinkAccountBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final GoRouter router = GoRouter.of(context);
    return Card(
      color: Colors.deepOrange,
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        title: Text(l10n.link_account_banner_message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white)),
        trailing: FilledButton.icon(
          icon: const Icon(Icons.person_add_alt_rounded),
          onPressed: () async {
            await router.push(CreateAccountView.routeName);
          },
          label: Text(l10n.link_account_banner_button_label),
        ),
      ),
    );
  }
}
