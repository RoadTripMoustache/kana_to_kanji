import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

const _mainKanaLastId = 46;
const _dakutenLastId = 71;
const _emptyTiles = [44, 45, 46, 37, 36];

class KanaList extends StatefulWidget {
  /// List of Kana.
  /// Required the entire kana list of the alphabet (107 kanas) otherwise a loading screen
  /// will be shown.
  final List<({Kana kana, bool disabled})> items;

  const KanaList({super.key, required this.items});

  @override
  State<KanaList> createState() => _KanaListState();
}

class _KanaListState extends State<KanaList> {
  final _scrollToWidgetKey =
      GlobalKey(debugLabel: "kana_list_scroll_to_widget_key");

  void _onPressed(Kana kana, BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Kana: ${kana.kana} tapped")));
  }

  @override
  void didUpdateWidget(KanaList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_scrollToWidgetKey.currentContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          _scrollToWidgetKey.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final scrollToIndex =
        widget.items.indexWhere((element) => !element.disabled);

    if (widget.items.isEmpty) {
      return Center(child: Text(l10n.nothing_to_show));
    }

    final sectionTextStyle = Theme.of(context).textTheme.titleLarge;
    const cleanTile = Card(elevation: 0);

    final List<Widget> main = widget.items
        .sublist(0, _mainKanaLastId)
        .map<Widget>((item) => KanaListTile(
              item.kana,
              key: item.kana.id == scrollToIndex ? _scrollToWidgetKey : null,
              disabled: item.disabled,
              onPressed: () => _onPressed(item.kana, context),
            ))
        .toList();
    for (int id in _emptyTiles) {
      main.insert(id, cleanTile);
    }

    final List<Widget> dakuten = widget.items
        .sublist(_mainKanaLastId, _dakutenLastId)
        .map<Widget>((item) => KanaListTile(item.kana,
            key: item.kana.id == scrollToIndex ? _scrollToWidgetKey : null,
            disabled: item.disabled,
            onPressed: () => _onPressed(item.kana, context)))
        .toList();
    final List<Widget> combination = widget.items
        .sublist(_dakutenLastId)
        .map<Widget>((item) => KanaListTile(item.kana,
            key: item.kana.id == scrollToIndex ? _scrollToWidgetKey : null,
            disabled: item.disabled,
            onPressed: () => _onPressed(item.kana, context)))
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
