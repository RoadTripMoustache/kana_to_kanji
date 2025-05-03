import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/glossary/pagination_helper.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

class KanjiList extends StatelessWidget {
  final Function(Kanji)? onPressed;

  final PaginationHelper<Kanji, dynamic> pagination;

  const KanjiList({required this.pagination, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => PagedListView<int, Kanji>(
    key: PageStorageKey("kanji_list_key"),
    state: pagination.pagingState,
    fetchNextPage: pagination.fetchNextPage,
    builderDelegate: PagedChildBuilderDelegate(
      firstPageProgressIndicatorBuilder: (context) => const Center(),
      newPageProgressIndicatorBuilder:
          (context) => const Center(child: RTMSpinner()),
      animateTransitions: true,
      transitionDuration: const Duration(milliseconds: 400),
      itemBuilder:
          (context, item, index) => GlossaryListTile.kanji(
            item,
            onPressed: () => onPressed?.call(item),
          ),
    ),
  );
}
