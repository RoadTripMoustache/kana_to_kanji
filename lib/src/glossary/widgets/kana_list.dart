import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

class KanaList extends StatelessWidget {
  /// List of Kana.
  /// Required the entire kana list of the alphabet (107 kanas) otherwise a loading screen
  /// will be shown.
  final List<Kana> items;

  /// Function to execute when a [KanaListTile] is pressed
  final Function(Kana kana)? onPressed;

  const KanaList({super.key, required this.items, this.onPressed});

  void _onPressed(Kana kana, BuildContext context) {
    if (onPressed != null) {
      onPressed!(kana);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (items.isEmpty) {
      return Center(child: Text(l10n.nothing_to_show));
    }

    final sectionTextStyle = Theme.of(context).textTheme.titleLarge;
    const cleanTile = Card(elevation: 0);

    final List<Widget> main = items
        .sublist(0, 46)
        .map<Widget>((kana) => KanaListTile(
              kana,
              onPressed: () => _onPressed(kana, context),
            ))
        .toList();
    main
      ..insertAll(44, const [cleanTile, cleanTile, cleanTile])
      ..insert(37, cleanTile)
      ..insert(36, cleanTile);
    final List<Widget> dakuten = items
        .sublist(46, 71)
        .map<Widget>((kana) =>
            KanaListTile(kana, onPressed: () => _onPressed(kana, context)))
        .toList();
    final List<Widget> combination = items
        .sublist(71)
        .map<Widget>((kana) =>
            KanaListTile(kana, onPressed: () => _onPressed(kana, context)))
        .toList();

    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            children: main,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(l10n.dakuten_kana, style: sectionTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Divider(height: 0, endIndent: 150),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            children: dakuten,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(l10n.combination_kana, style: sectionTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Divider(height: 0, endIndent: 150),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.8,
            children: combination,
          ),
        ]));
  }
}
