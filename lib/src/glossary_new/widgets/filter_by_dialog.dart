import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";

class FilterByDialog extends StatefulWidget {
  final List<JLPTLevel> selectedJlptLevel;

  final List<KnowledgeLevel> selectedKnowledgeLevel;

  final void Function(
    List<JLPTLevel> selectedJlptLevel,
    List<KnowledgeLevel> selectedKnowledgeLevel,
  )
  onSubmit;

  const FilterByDialog({
    required this.onSubmit,
    this.selectedJlptLevel = const [],
    this.selectedKnowledgeLevel = const [],
    super.key,
  });

  @override
  State<FilterByDialog> createState() => _FilterByDialogState();
}

class _FilterByDialogState extends State<FilterByDialog> {
  final List<JLPTLevel> selectedJlptLevel = [];
  final List<KnowledgeLevel> selectedKnowledgeLevel = [];

  @override
  void initState() {
    super.initState();
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

  void onClear() {
    selectedJlptLevel.clear();
    selectedKnowledgeLevel.clear();
    onSubmit();
  }

  void onSubmit() {
    widget.onSubmit(selectedJlptLevel, selectedKnowledgeLevel);
    context.pop();
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
        children: [
          Row(
            children: [
              Text(l10n.jlpt_level_title, style: textTheme.titleMedium),
            ],
          ),
          Wrap(
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
          Row(
            children: [
              Text(l10n.knowledge_level_title, style: textTheme.titleMedium),
            ],
          ),
          Wrap(
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
          RTMSpacer.p16(),
          RTMTextButton(
            onPressed: onClear,
            child: Text(l10n.glossary_filter_by_clear),
          ),
          RTMFilledButton(
            onPressed: onSubmit,
            child: Text(l10n.glossary_filter_by_apply),
          ),
        ],
      ),
    );
  }
}
