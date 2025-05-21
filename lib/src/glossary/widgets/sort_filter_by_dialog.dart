import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";

class SortFilterByDialog extends StatefulWidget {
  final List<JLPTLevel> selectedJlptLevel;

  final List<KnowledgeLevel> selectedKnowledgeLevel;

  final SortOrder sortOrder;

  final void Function(List<JLPTLevel>, List<KnowledgeLevel>, SortOrder)
  onSubmit;

  const SortFilterByDialog({
    required this.onSubmit,
    this.sortOrder = SortOrder.alphabetical,
    this.selectedJlptLevel = const [],
    this.selectedKnowledgeLevel = const [],
    super.key,
  });

  @override
  State<SortFilterByDialog> createState() => _SortFilterByDialogState();
}

class _SortFilterByDialogState extends State<SortFilterByDialog> {
  late SortOrder sortOrder;
  final List<JLPTLevel> selectedJlptLevel = [];
  final List<KnowledgeLevel> selectedKnowledgeLevel = [];

  @override
  void initState() {
    super.initState();
    sortOrder = widget.sortOrder;
    selectedJlptLevel.addAll(widget.selectedJlptLevel);
    selectedKnowledgeLevel.addAll(widget.selectedKnowledgeLevel);
  }

  void toggleJLPTLevel(JLPTLevel jlptLevel) {
    setState(() {
      if (selectedJlptLevel.contains(jlptLevel)) {
        selectedJlptLevel.remove(jlptLevel);
      } else {
        selectedJlptLevel.add(jlptLevel);
      }
    });
  }

  void toggleKnowledgeLevel(KnowledgeLevel knowledgeLevel) {
    setState(() {
      if (selectedKnowledgeLevel.contains(knowledgeLevel)) {
        selectedKnowledgeLevel.remove(knowledgeLevel);
      } else {
        selectedKnowledgeLevel.add(knowledgeLevel);
      }
    });
  }

  void onSortOrderChanged(Set<SortOrder> value) {
    setState(() {
      sortOrder = value.first;
    });
  }

  void onClear() {
    selectedJlptLevel.clear();
    selectedKnowledgeLevel.clear();
    onSubmit(overrideSortOrder: widget.sortOrder);
  }

  void onSubmit({SortOrder? overrideSortOrder}) {
    widget.onSubmit(
      selectedJlptLevel,
      selectedKnowledgeLevel,
      overrideSortOrder ?? sortOrder,
    );
    // Only present for testing
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // Keep sake as alternative UI
          // Text(
          //   l10n.glossary_sort_by_title,
          //   style: textTheme.titleLarge,
          // ),
          // Align(
          //   child: SegmentedButton(
          //     segments: [
          //       ButtonSegment<SortOrder>(
          //         value: SortOrder.alphabetical,
          //         label: Text(l10n.glossary_sort_by_alphabetical),
          //       ),
          //       ButtonSegment<SortOrder>(
          //         value: SortOrder.japanese,
          //         label: Text(l10n.glossary_sort_by_japanese),
          //       ),
          //     ],
          //     selected: {sortOrder},
          //     onSelectionChanged: onSortOrderChanged,
          //     showSelectedIcon: false,
          //   ),
          // ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.glossary_sort_by_title,
              style: textTheme.titleLarge,
            ),
            trailing: SegmentedButton(
              segments: [
                ButtonSegment<SortOrder>(
                  value: SortOrder.alphabetical,
                  label: Text(l10n.glossary_sort_by_alphabetical),
                ),
                ButtonSegment<SortOrder>(
                  value: SortOrder.japanese,
                  label: Text(l10n.glossary_sort_by_japanese),
                ),
              ],
              selected: {sortOrder},
              onSelectionChanged: onSortOrderChanged,
              showSelectedIcon: false,
            ),
          ),
          Text(l10n.glossary_filter_by_title, style: textTheme.titleLarge),
          Text(l10n.jlpt_level_title, style: textTheme.titleMedium),
          Align(
            child: Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children:
                  JLPTLevel.values
                      .map(
                        (level) => FilterChip(
                          label: Text(l10n.jlpt_level_short(level.value)),
                          selected: selectedJlptLevel.contains(level),
                          onSelected: (_) => toggleJLPTLevel(level),
                        ),
                      )
                      .toList(),
            ),
          ),
          Text(l10n.knowledge_level_title, style: textTheme.titleMedium),
          Align(
            child: Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children:
                  KnowledgeLevel.values
                      .map(
                        (level) => FilterChip(
                          label: Text(l10n.knowledge_level(level.name)),
                          selected: selectedKnowledgeLevel.contains(level),
                          onSelected: (_) => toggleKnowledgeLevel(level),
                        ),
                      )
                      .toList(),
            ),
          ),
          RTMSpacer.p8(), // 8 + 16 = 24px
          Column(
            children: [
              RTMFilledButton(
                onPressed: onSubmit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(l10n.glossary_filter_by_apply)],
                ),
              ),
              RTMTextButton(
                onPressed: onClear,
                child: Text(l10n.glossary_filter_by_clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
