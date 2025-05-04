import "package:flutter/material.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";

class SearchNoResult extends StatelessWidget {
  final ResourceType type;

  const SearchNoResult({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? titleStyle = textTheme.titleLarge;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text(l10n.glossary_not_found(type.name), style: titleStyle),
          Text(l10n.glossary_not_found_subtitle, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
