import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class KanjiList extends StatefulWidget {
  final List<Kanji> items;

  /// Function to execute when a [GlossaryListTile] is pressed
  final Function(Kanji kanji)? onPressed;

  const KanjiList({required this.items, super.key, this.onPressed});

  @override
  State<KanjiList> createState() => _KanjiListState();
}

class _KanjiListState extends State<KanjiList> {
  final _numberOfPostsPerRequest = 10;

  final PagingController<int, Kanji> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      widget.items.sort((a, b) => a.uid.uid.compareTo(b.uid.uid));
      List<Kanji> kanjiList = [];
      for (var i = pageKey * _numberOfPostsPerRequest;
          i < (pageKey + 1) * _numberOfPostsPerRequest &&
              i < widget.items.length;
          i++) {
        kanjiList.add(widget.items.elementAt(i));
      }

      final isLastPage =
          widget.items.length <= (pageKey + 1) * _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(kanjiList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(kanjiList, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pagingController.refresh();
    return PagedListView<int, Kanji>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Kanji>(
          itemBuilder: (context, item, index) =>
              GlossaryListTile.kanji(item, onPressed: () => _onPressed(item)),
        ));
  }

  void _onPressed(Kanji kanji) {
    if (widget.onPressed != null) {
      widget.onPressed!(kanji);
    }
  }
}
