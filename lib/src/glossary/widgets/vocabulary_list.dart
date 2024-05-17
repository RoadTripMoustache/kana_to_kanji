import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VocabularyList extends StatefulWidget {
  final List<Vocabulary> items;

  /// Function to execute when a [GlossaryListTile] is pressed
  final Function(Vocabulary kanji)? onPressed;

  const VocabularyList({required this.items, super.key, this.onPressed});

  @override
  State<VocabularyList> createState() => _VocabularyListState();
}

class _VocabularyListState extends State<VocabularyList> {
  final _numberOfPostsPerRequest = 10;

  final PagingController<int, Vocabulary> _pagingController =
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
      List<Vocabulary> vocabularyList = [];
      for (var i = pageKey * _numberOfPostsPerRequest;
          i < (pageKey + 1) * _numberOfPostsPerRequest &&
              i < widget.items.length;
          i++) {
        vocabularyList.add(widget.items.elementAt(i));
      }

      final isLastPage =
          widget.items.length <= (pageKey + 1) * _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(vocabularyList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(vocabularyList, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pagingController.refresh();
    return PagedListView<int, Vocabulary>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Vocabulary>(
          itemBuilder: (context, item, index) => GlossaryListTile.vocabulary(
              item,
              onPressed: () => _onPressed(item)),
        ));
  }

  void _onPressed(Vocabulary vocabulary) {
    if (widget.onPressed != null) {
      widget.onPressed!(vocabulary);
    }
  }
}
