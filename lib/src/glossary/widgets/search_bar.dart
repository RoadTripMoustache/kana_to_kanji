import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const _duration = Duration(milliseconds: 400);

class GlossarySearchBar extends StatelessWidget {
  final void Function(String searchText) searchGlossary;

  const GlossarySearchBar({super.key, required this.searchGlossary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GlossarySearchBarContent(
            maxWidth: constraints.maxWidth, searchGlossary: searchGlossary);
      },
    );
  }
}

class GlossarySearchBarContent extends StatefulWidget {
  final double maxWidth;
  final void Function(String searchText) searchGlossary;

  const GlossarySearchBarContent(
      {super.key, required this.maxWidth, required this.searchGlossary});

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
  double searchBarWidth = 64;

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
      return 64.0;
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
    _focusNode.unfocus();
    _focusNode.requestFocus();
    focusInSearch();
  }

  void focusOutSearch(event) {
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
          height: 64,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(l10n.glossary_view_title),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.filter_list_rounded),
                      ),
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.tune),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        if (isOpen && isSearchMade)
          InkWell(
            key: const Key("glossary_bar_cancel_search_icon"),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Colors.transparent,
            onTap: cancelSearch,
            child: const SizedBox(
              width: 36,
              height: 64,
              child: Icon(Icons.arrow_back),
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
                  borderRadius: BorderRadius.circular(borderRadius)),
              width: searchBarWidth,
              height: 64.0,
              alignment: Alignment.center,
              duration: _duration,
              clipBehavior: Clip.hardEdge,
              child: TextField(
                  key: const Key("glossary_bar_search_text_field"),
                  controller: _controller,
                  focusNode: _focusNode,
                  autocorrect: false,
                  autofocus: false,
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
                      hintStyle:
                          const TextStyle(decoration: TextDecoration.none),
                      fillColor: Colors.transparent,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      prefixIcon: !isSearchMade
                          ? InkWell(
                              key: const Key("glossary_bar_search_icon"),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              focusColor: Theme.of(context).colorScheme.secondary,
                              highlightColor: Colors.transparent,
                              onTap: onTapGlass,
                              child: const SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(Icons.search),
                              ),
                            )
                          : null,
                      suffixIcon: isInputFilled
                          ? InkWell(
                              key: const Key("glossary_bar_clear_search_icon"),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              focusColor: Theme.of(context).colorScheme.secondary,
                              highlightColor: Colors.transparent,
                              onTap: clearSearch,
                              child: const SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(Icons.clear_rounded),
                              ),
                            )
                          : null))),
        ),
      ],
    );
  }
}
