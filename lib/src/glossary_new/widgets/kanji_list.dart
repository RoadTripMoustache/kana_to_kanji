import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

class KanjiList extends StatelessWidget {
  final Function(Kanji)? onPressed;

  final PagingState<int, Kanji> pagingState;

  final VoidCallback fetchNextPage;

  const KanjiList({
    required this.pagingState,
    required this.fetchNextPage,
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => PagedListView<int, Kanji>(
    state: pagingState,
    fetchNextPage: fetchNextPage,
    builderDelegate: PagedChildBuilderDelegate(
      itemBuilder:
          (context, item, index) => GlossaryListTile.kanji(
            item,
            onPressed: () => onPressed?.call(item),
          ),
    ),
  );
}
