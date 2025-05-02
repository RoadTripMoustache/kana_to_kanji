import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/glossary_new/view_model.dart";
import "package:kana_to_kanji/src/glossary_new/widgets/kana_tile.dart";

const _emptyTiles = [44, 45, 46, 37, 36];

class KanaList extends StatefulWidget {
  final KanaMap items;
  final Function(Kana kana)? onPressed;

  const KanaList({required this.items, super.key, this.onPressed});

  @override
  State<KanaList> createState() => _KanaListState();
}

class _KanaListState extends State<KanaList> {
  late final List<KanaDisabled?> _mainWithEmptyTiles;

  @override
  void initState() {
    super.initState();
    _mainWithEmptyTiles = _prepareMainList();
  }

  List<KanaDisabled?> _prepareMainList() {
    final mainItems = widget.items[KanaTypes.main] ?? [];
    final list = List<KanaDisabled?>.from(mainItems);

    for (final int id in _emptyTiles) {
      if (id < list.length) {
        list.insert(id, null);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<KanaDisabled> dakuten = widget.items[KanaTypes.dakuten] ?? [];
    final List<KanaDisabled> combination =
        widget.items[KanaTypes.combination] ?? [];
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (widget.items.isEmpty) {
      return Center(child: Text(l10n.nothing_to_show));
    }

    return CustomScrollView(
      slivers: [
        _buildKanaGrid(_mainWithEmptyTiles, 5),
        _buildSectionHeader(l10n.dakuten_kana),
        _buildKanaGrid(dakuten, 5),
        _buildSectionHeader(l10n.combination_kana),
        _buildKanaGrid(combination, 3, childAspectRatio: 1.8),
      ],
    );
  }

  Widget _buildSectionHeader(String title) => SliverToBoxAdapter(
    child: Padding(
      padding: const RTMPadding.horizontal8(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Divider(height: 0, endIndent: 150),
        ],
      ),
    ),
  );

  Widget _buildKanaGrid(
    List<KanaDisabled?> items,
    int crossAxisCount, {
    double childAspectRatio = 1.0,
  }) => SliverGrid.builder(
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      final item = items[index];
      return item != null
          ? KanaTile(
            item.kana,
            disabled: item.disabled,
            onPressed: () => widget.onPressed?.call(item.kana),
          )
          : const RTMCard(elevation: 0);
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    ),
  );
}
