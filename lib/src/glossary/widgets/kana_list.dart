import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart";

const _mainKanaLastId = 46;
const _dakutenLastId = 71;
const _emptyTiles = [44, 45, 46, 37, 36];

class KanaList extends StatefulWidget {
  /// List of Kana.
  /// Required the entire kana list of the alphabet (107 kanas) otherwise
  /// a loading screen will be shown.
  final List<({Kana kana, bool disabled})> items;

  /// Function to execute when a [KanaListTile] is pressed
  final Function(Kana kana)? onPressed;

  const KanaList({required this.items, super.key, this.onPressed});

  @override
  State<KanaList> createState() => _KanaListState();
}

class _KanaListState extends State<KanaList> {
  final _scrollToWidgetKey =
      GlobalKey(debugLabel: "kana_list_scroll_to_widget_key");

  final List<({Kana kana, bool disabled})?> main = [];
  final List<({Kana kana, bool disabled})> dakuten = [];
  final List<({Kana kana, bool disabled})> combination = [];

  void _onPressed(Kana kana) {
    widget.onPressed?.call(kana);
  }

  void _splitKanaList() {
    if (widget.items.length < 107) {
      return;
    }
    main
      ..clear()
      ..addAll(widget.items.sublist(0, _mainKanaLastId));
    for (final int id in _emptyTiles) {
      main.insert(id, null);
    }
    dakuten
      ..clear()
      ..addAll(widget.items.sublist(_mainKanaLastId, _dakutenLastId));
    combination
      ..clear()
      ..addAll(widget.items.sublist(_dakutenLastId));
  }


  @override
  void initState() {
    _splitKanaList();
    super.initState();
  }

  @override
  void didUpdateWidget(KanaList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _splitKanaList();

    if (_scrollToWidgetKey.currentContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_scrollToWidgetKey.currentContext != null) {
          await Scrollable.ensureVisible(
            _scrollToWidgetKey.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
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

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: main.length,
            itemBuilder: (BuildContext context, int index) =>
                main[index] != null
                    ? KanaListTile(
                        main[index]!.kana,
                        key: main[index]!.kana.position == scrollToIndex
                            ? _scrollToWidgetKey
                            : null,
                        disabled: main[index]!.disabled,
                        onPressed: () => _onPressed(main[index]!.kana),
                      )
                    : const Card(elevation: 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(l10n.dakuten_kana, style: sectionTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Divider(height: 0, endIndent: 150),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dakuten.length,
            itemBuilder: (BuildContext context, int index) => KanaListTile(
              dakuten[index].kana,
              key: dakuten[index].kana.position == scrollToIndex
                  ? _scrollToWidgetKey
                  : null,
              disabled: dakuten[index].disabled,
              onPressed: () => _onPressed(dakuten[index].kana),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(l10n.combination_kana, style: sectionTextStyle),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Divider(height: 0, endIndent: 150),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: combination.length,
            itemBuilder: (BuildContext context, int index) => KanaListTile(
              combination[index].kana,
              key: combination[index].kana.position == scrollToIndex
                  ? _scrollToWidgetKey
                  : null,
              disabled: combination[index].disabled,
              onPressed: () => _onPressed(combination[index].kana),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1.8),
          ),
        ]));
  }
}
