import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";

const _duration = Duration(milliseconds: 500);

class HiddenSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final void Function(String searchText) onSearch;

  final PreferredSizeWidget? bottom;

  const HiddenSearchBar({
    required this.title,
    required this.onSearch,
    this.actions = const [],
    this.bottom,
    super.key,
  });

  @override
  State<HiddenSearchBar> createState() => _SearchBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _SearchBarState extends State<HiddenSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (_isSearchMode) {
        _animationController.forward();
        _focusNode.requestFocus();
      } else {
        _animationController.reverse();
        _focusNode.unfocus();
        _controller.clear();
        widget.onSearch("");
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    _focusNode.requestFocus();
    widget.onSearch("");
  }

  void _handleSearch(String value) {
    widget.onSearch(value);
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder:
          (context, child) => AppBar(
            centerTitle: false,
            title: LayoutBuilder(
              builder:
                  (context, constraints) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Title that slides out when search is activated
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(-2.0, 0.0),
                        ).animate(_animation),
                        child: FadeTransition(
                          opacity: ReverseAnimation(_animation),
                          child: Text(widget.title),
                        ),
                      ),

                      // Search field that slides in when search is activated
                      if (_isSearchMode || _animationController.value > 0)
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.5, 0.0),
                            end: Offset.zero,
                          ).animate(_animation),
                          child: FadeTransition(
                            opacity: _animation,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animate icon sliding in and out
                                  if (_controller.text.isEmpty)
                                    RTMIconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: _toggleSearchMode,
                                    ),
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                        hintText: l10n.glossary_search_bar_hint,
                                        suffixIcon:
                                            _controller.text.isNotEmpty
                                                ? RTMIconButton(
                                                  icon: const Icon(Icons.clear),
                                                  onPressed: _clearSearch,
                                                )
                                                : null,
                                      ),
                                      onSubmitted: _handleSearch,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
            ),
            actions: [
              if (!_isSearchMode)
                RTMIconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearchMode,
                ),
              ...widget.actions,
            ],
            bottom: widget.bottom,
          ),
    );
  }
}
