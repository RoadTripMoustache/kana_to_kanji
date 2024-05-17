import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";

class SortBy extends StatefulWidget {
  final void Function(SortOrder selectedOrder) sortGlossary;
  final SortOrder selectedOrder;

  const SortBy({
    required this.sortGlossary,
    required this.selectedOrder,
    super.key,
  });

  @override
  State<SortBy> createState() => _SortBy();
}

class _SortBy extends State<SortBy> {
  late SortOrder _selectedOrder;

  @override
  void initState() {
    super.initState();
    _selectedOrder = widget.selectedOrder;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            widget.sortGlossary(_selectedOrder);
          },
        ),
        title: Text(l10n.glossary_sort_by_title),
      ),
      body: Column(
        children: [
          RadioListTile(
              visualDensity: VisualDensity.compact,
              title: Text(l10n.glossary_sort_by_alphabetical),
              value: SortOrder.alphabetical,
              groupValue: _selectedOrder,
              onChanged: (SortOrder? value) {
                if (value != null) {
                  setState(() {
                    _selectedOrder = value;
                  });
                }
              }),
          RadioListTile(
            visualDensity: VisualDensity.compact,
            title: Text(l10n.glossary_sort_by_japanese),
            value: SortOrder.japanese,
            groupValue: _selectedOrder,
            onChanged: (SortOrder? value) {
              if (value != null) {
                setState(() {
                  _selectedOrder = value;
                });
              }
            },
          )
        ],
      ),
    );
  }
}
