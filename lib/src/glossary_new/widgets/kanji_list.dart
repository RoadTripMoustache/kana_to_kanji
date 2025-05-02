import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import "package:kana_to_kanji/src/glossary_new/pagination_helper.dart";

class KanjiList extends StatelessWidget {
  final Function(Kanji)? onPressed;

  final PaginationHelper<Kanji, dynamic> pagination;

  const KanjiList({required this.pagination, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => PagedListView<int, Kanji>(
    state: pagination.pagingState,
    fetchNextPage: pagination.fetchNextPage,
    builderDelegate: PagedChildBuilderDelegate(
      itemBuilder:
          (context, item, index) => GlossaryListTile.kanji(
            item,
            onPressed: () => onPressed?.call(item),
          ),
    ),
  );
}
