import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/glossary/widgets/filter_by.dart";
import "package:kana_to_kanji/src/glossary/widgets/sort_by.dart";

const _duration = Duration(milliseconds: 400);

class GlossarySearchBar extends StatelessWidget {
  final void Function(String searchText) searchGlossary;
  final void Function() filterGlossary;
  final void Function(SortOrder newSelectedOrder) sortGlossary;
  final List<JLPTLevel> selectedJlptLevel;
  final List<KnowledgeLevel> selectedKnowledgeLevel;
  final SortOrder selectedOrder;

  const GlossarySearchBar({
    required this.searchGlossary,
    required this.filterGlossary,
    required this.sortGlossary,
    required this.selectedJlptLevel,
    required this.selectedKnowledgeLevel,
    required this.selectedOrder,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (BuildContext context, BoxConstraints constraints) =>
            GlossarySearchBarContent(
              maxWidth: constraints.maxWidth,
              searchGlossary: searchGlossary,
              filterGlossary: filterGlossary,
              sortGlossary: sortGlossary,
              selectedJlptLevel: selectedJlptLevel,
              selectedKnowledgeLevel: selectedKnowledgeLevel,
              selectedOrder: selectedOrder,
            ),
  );
}

class GlossarySearchBarContent extends StatefulWidget {
  final double maxWidth;
  final void Function(String searchText) searchGlossary;
  final void Function() filterGlossary;
  final void Function(SortOrder newSelectedOrder) sortGlossary;
  final List<JLPTLevel> selectedJlptLevel;
  final List<KnowledgeLevel> selectedKnowledgeLevel;
  final SortOrder selectedOrder;

  const GlossarySearchBarContent({
    required this.maxWidth,
    required this.searchGlossary,
    required this.filterGlossary,
    required this.sortGlossary,
    required this.selectedJlptLevel,
    required this.selectedKnowledgeLevel,
    required this.selectedOrder,
    super.key,
  });

  @override
  State<GlossarySearchBarContent> createState() => _GlossarySearchBarState();
}

class _GlossarySearchBarState extends State<GlossarySearchBarContent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Color color = Colors.transparent;
  double borderRadius = 32;
  double margin = 1;
  bool isOpen = false;

  bool get isInputFilled => _controller.text.isNotEmpty;
  bool isSearchMade = false;
  double searchBarWidth = kToolbarHeight;

  @override
  void initState() {
    super.initState();
  }

  void changeSearchBarAnimationState() {
    setState(() {
      if (isOpen && !_focusNode.hasFocus) {
        color = Theme.of(context).colorScheme.inversePrimary;
      } else if (isOpen && _focusNode.hasFocus) {
        color = Theme.of(context).colorScheme.inversePrimary;
      } else {
        color = Colors.transparent;
      }
      searchBarWidth = calculateSearchBarWidth();
    });
  }

  double calculateSearchBarWidth() {
    if (!isOpen) {
      return kToolbarHeight;
    }
    var newWidth = widget.maxWidth;
    if (_focusNode.hasFocus) {
      newWidth = newWidth - 94.0;
    }
    if (isSearchMade) {
      newWidth = newWidth - 40;
    }
    return newWidth;
  }

  /// Event trigger when the glass icon is tapped.
  /// - Open the search bar if closed
  /// - Close the search bar if the input is empty
  /// - Trigger a search if the input is not empty
  void onTapGlass() {
    if (!isOpen) {
      isOpen = true;
      _focusNode.requestFocus();
    } else if (_controller.text.isEmpty) {
      isOpen = false;
      _focusNode.unfocus();
      widget.searchGlossary("");
    } else {
      isSearchMade = true;
      _focusNode.unfocus();
      onSubmit(_controller.text);
    }
    changeSearchBarAnimationState();
  }

  void clearSearch() {
    _controller.clear();
    isSearchMade = false;
    _focusNode
      ..unfocus()
      ..requestFocus();
    focusInSearch();
    widget.searchGlossary("");
  }

  void focusOutSearch(PointerDownEvent? event) {
    _focusNode.unfocus();
    changeSearchBarAnimationState();
  }

  void focusInSearch() {
    _focusNode.requestFocus();
    changeSearchBarAnimationState();
  }

  void cancelSearch() {
    isSearchMade = false;
    clearSearch();
    focusOutSearch(null);
    isOpen = false;
    changeSearchBarAnimationState();
    widget.searchGlossary("");
  }

  void onSubmit(String searchTxt) {
    if (searchTxt != "") {
      isSearchMade = true;
      focusOutSearch(null);
      widget.searchGlossary(searchTxt);
    } else {
      _focusNode.requestFocus();
    }
  }

  Route _createRouteFilterBy() => PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) => FilterBy(
          filterGlossary: widget.filterGlossary,
          selectedJlptLevel: widget.selectedJlptLevel,
          selectedKnowledgeLevel: widget.selectedKnowledgeLevel,
        ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  Route _createRouteSortBy() => PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) => SortBy(
          sortGlossary: widget.sortGlossary,
          selectedOrder: widget.selectedOrder,
        ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: Center(child: Text(l10n.glossary_view_title)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(_createRouteSortBy());
                      },
                      icon: const Icon(Icons.filter_list_rounded),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Navigator.of(
                          context,
                        ).push(_createRouteFilterBy());
                      },
                      icon: const Icon(Icons.tune_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isOpen && isSearchMade)
          InkWell(
            key: const Key("glossary_bar_cancel_search_icon"),
            borderRadius: BorderRadius.circular(25),
            hoverColor: Theme.of(context).colorScheme.secondary,
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Colors.transparent,
            onTap: cancelSearch,
            child: const SizedBox(
              width: 36,
              height: kToolbarHeight,
              child: Icon(Icons.arrow_back_rounded),
            ),
          ),
        AnimatedPositioned(
          width: searchBarWidth,
          duration: _duration,
          left: isSearchMade ? 36 : 0,
          child: AnimatedContainer(
            margin: EdgeInsets.all(margin),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            width: searchBarWidth,
            height: kToolbarHeight - 2,
            alignment: Alignment.center,
            duration: _duration,
            clipBehavior: Clip.hardEdge,
            child: TextField(
              key: const Key("glossary_bar_search_text_field"),
              controller: _controller,
              focusNode: _focusNode,
              autocorrect: false,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.send,
              onTapOutside: focusOutSearch,
              onTap: focusInSearch,
              onSubmitted: onSubmit,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: isOpen ? l10n.glossary_search_bar_hint : "",
                hintStyle: const TextStyle(decoration: TextDecoration.none),
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                prefixIcon:
                    !isSearchMade
                        ? InkWell(
                          key: const Key("glossary_bar_search_icon"),
                          borderRadius: BorderRadius.circular(25),
                          hoverColor: Theme.of(context).colorScheme.secondary,
                          splashColor: Theme.of(context).colorScheme.secondary,
                          focusColor: Theme.of(context).colorScheme.secondary,
                          highlightColor: Colors.transparent,
                          onTap: onTapGlass,
                          child: const SizedBox(
                            width: kToolbarHeight,
                            height: kToolbarHeight,
                            child: Icon(Icons.search_rounded),
                          ),
                        )
                        : null,
                suffixIcon:
                    isInputFilled
                        ? InkWell(
                          key: const Key("glossary_bar_clear_search_icon"),
                          borderRadius: BorderRadius.circular(25),
                          hoverColor: Theme.of(context).colorScheme.secondary,
                          splashColor: Theme.of(context).colorScheme.secondary,
                          focusColor: Theme.of(context).colorScheme.secondary,
                          highlightColor: Colors.transparent,
                          onTap: clearSearch,
                          child: const SizedBox(
                            width: kToolbarHeight,
                            height: kToolbarHeight,
                            child: Icon(Icons.clear_rounded),
                          ),
                        )
                        : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
