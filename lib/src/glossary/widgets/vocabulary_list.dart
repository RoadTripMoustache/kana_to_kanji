import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/pagination_helper.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import "package:kana_to_kanji/src/glossary/widgets/search_no_result.dart";

class VocabularyList extends StatelessWidget {
  final Function(Vocabulary)? onPressed;

  final PaginationHelper<Vocabulary, dynamic> pagination;

  const VocabularyList({required this.pagination, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => PagedListView<int, Vocabulary>(
    key: PageStorageKey("vocabulary_list_key"),
    state: pagination.pagingState,
    fetchNextPage: pagination.fetchNextPage,
    builderDelegate: PagedChildBuilderDelegate(
      firstPageProgressIndicatorBuilder: (context) => const Center(),
      newPageProgressIndicatorBuilder:
          (context) => const Center(child: RTMSpinner()),
      noItemsFoundIndicatorBuilder:
          (context) => const SearchNoResult(type: ResourceType.vocabulary),
      animateTransitions: true,
      transitionDuration: const Duration(milliseconds: 400),
      itemBuilder:
          (context, item, index) => GlossaryListTile.vocabulary(
            item,
            onPressed: () => onPressed?.call(item),
          ),
    ),
  );
}
