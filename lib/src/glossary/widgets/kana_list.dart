import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/glossary/constants.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_tile.dart";

const _emptyTiles = [44, 45, 46, 37, 36];
const _mainKanaRows = 51 ~/ 5; // 46 kana + 5 empty tiles
const _dakutenKanaRows = 25 ~/ 5;

class KanaList extends StatefulWidget {
  final KanaMap items;
  final Function(Kana kana)? onPressed;
  final bool visited;

  const KanaList({
    required this.items,
    super.key,
    this.onPressed,
    this.visited = false,
  });

  @override
  State<KanaList> createState() => _KanaListState();
}

class _KanaListState extends State<KanaList> {
  late final double _screenWidth;

  final ScrollController _scrollController = ScrollController();

  late List<KanaDisabled?> _mainWithEmptyTiles;

  /// The position of the last kana we scrolled to
  int _lastKanaScrolledTo = 0;

  @override
  void initState() {
    super.initState();
    _mainWithEmptyTiles = _prepareMainList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenWidth = MediaQuery.of(context).size.width;
      unawaited(_scrollTo());
    });
  }

  @override
  void didUpdateWidget(covariant KanaList oldWidget) {
    // Rebuild the main list on every update as widget.items is
    // passed by reference, making it complex to track changes without a deep
    // comparison.
    _mainWithEmptyTiles = _prepareMainList();
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_scrollTo());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _scrollTo() async {
    final Kana? kana = _determineFirstTileEnabled();

    // No need to scroll either all kanas are disabled or
    // the user has already visited the page and so we assume we already
    // scrolled to the correct position.
    if (kana == null ||
        (widget.visited && _lastKanaScrolledTo == kana.position)) {
      return;
    }

    final double offset = _determineScrollOffset(kana);
    _lastKanaScrolledTo = kana.position;
    await _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Kana? _determineFirstTileEnabled() {
    KanaDisabled? kana =
        widget.items[KanaTypes.main]!
            .where((item) => !item.disabled)
            .firstOrNull;

    kana ??=
        widget.items[KanaTypes.dakuten]!
            .where((item) => !item.disabled)
            .firstOrNull;
    kana ??=
        widget.items[KanaTypes.combination]!
            .where((item) => !item.disabled)
            .firstOrNull;

    return kana?.kana;
  }

  double _determineScrollOffset(Kana kana) {
    final int itemPerRow = kana.type == KanaTypes.combination ? 3 : 5;
    final double aspectRatio = kana.type == KanaTypes.combination ? 1.8 : 1.0;
    final double tileWidth = _screenWidth / itemPerRow;
    final double tileHeight = tileWidth / aspectRatio;
    final int row = _getIndex(kana) ~/ itemPerRow;

    return row * tileHeight + _additionalOffset(kana.type);
  }

  /// Get [kana] index inside [widget.items[kana.type]]
  int _getIndex(Kana kana) {
    final KanaTypes type = kana.type;
    final map =
        type == KanaTypes.main ? _mainWithEmptyTiles : widget.items[type] ?? [];
    final index = map.indexWhere((item) => item?.kana == kana);

    if (index < 1) {
      return 0;
    }
    return index;
  }

  /// Determine the height of all the sections before [type]'s section
  double _additionalOffset(KanaTypes type) {
    switch (type) {
      case KanaTypes.main:
        return 0;
      case KanaTypes.dakuten:
        return _determineGridSectionHeight(KanaTypes.main);
      case KanaTypes.combination:
        return _determineGridSectionHeight(KanaTypes.main) +
            _determineGridSectionHeight(KanaTypes.dakuten);
    }
  }

  /// Calculates the approximate height of [type] grid
  double _determineGridSectionHeight(KanaTypes type) {
    switch (type) {
      case KanaTypes.main:
        return _screenWidth / 5 / 1.0 * _mainKanaRows;
      case KanaTypes.dakuten:
        return _screenWidth / 5 / 1.0 * _dakutenKanaRows;
      case KanaTypes.combination:
        // No need to determine as there is no other section after this one.
        // It is so impossible to have to cross that section
        return 0;
    }
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
      key: PageStorageKey(
        "kana_list_${dakuten.firstOrNull?.kana.alphabet.name}_key",
      ),
      controller: _scrollController,
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
      padding: const RTMPadding.all8(),
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
