import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";

class ChipList extends StatefulWidget {
  final List<Widget> children;

  final Widget? emptyListLabel;

  final int maxLines;

  const ChipList({
    required this.children,
    super.key,
    this.maxLines = 2,
    this.emptyListLabel,
  });

  @override
  State<ChipList> createState() => _ChipListState();
}

class _ChipListState extends State<ChipList> {
  static const _kChipSize = 48;

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                showAll && widget.children.isNotEmpty
                    ? double.infinity
                    : _kChipSize * (widget.maxLines + 0.3),
          ),
          child:
              widget.children.isEmpty && widget.emptyListLabel != null
                  ? Center(child: widget.emptyListLabel)
                  : Wrap(
                    spacing: 6.0,
                    clipBehavior: Clip.hardEdge,
                    children: widget.children,
                  ),
        ),
        if (widget.children.isNotEmpty)
          RTMTextButton.icon(
            icon: Icon(
              showAll
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            onPressed: () {
              setState(() {
                showAll = !showAll;
              });
            },
            label: Text(showAll ? l10n.show_less : l10n.show_more),
          ),
      ],
    );
  }
}
