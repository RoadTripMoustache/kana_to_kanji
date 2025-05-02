import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import "package:kana_to_kanji/src/glossary_new/pagination_helper.dart";

class VocabularyList extends StatelessWidget {
  final Function(Vocabulary)? onPressed;

  final PaginationHelper<Vocabulary, dynamic> pagination;

  const VocabularyList({required this.pagination, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => PagedListView<int, Vocabulary>(
    state: pagination.pagingState,
    fetchNextPage: pagination.fetchNextPage,
    builderDelegate: PagedChildBuilderDelegate(
      itemBuilder:
          (context, item, index) => GlossaryListTile.vocabulary(
            item,
            onPressed: () => onPressed?.call(item),
          ),
    ),
  );
}
