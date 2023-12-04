import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_level.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';

class FilterBy extends StatefulWidget {
  final void Function() filterGlossary;
  final List<JLPTLevel> selectedJlptLevel;
  final List<KnowledgeLevel> selectedKnowledgeLevel;

  const FilterBy({
    super.key,
    required this.filterGlossary,
    required this.selectedJlptLevel,
    required this.selectedKnowledgeLevel,
  });

  @override
  State<FilterBy> createState() => _FilterBy();

}

class _FilterBy extends State<FilterBy> {

  late List<JLPTLevel> _selectedJlptLevel;
  late List<KnowledgeLevel> _selectedKnowledgeLevel;

  @override
  void initState() {
    super.initState();
    _selectedJlptLevel = widget.selectedJlptLevel;
    _selectedKnowledgeLevel = widget.selectedKnowledgeLevel;
  }

  void _toggleJLPTLevel(JLPTLevel jlptLevel) {
    if (_selectedJlptLevel.contains(jlptLevel)) {
      _selectedJlptLevel.remove(jlptLevel);
    } else {
      _selectedJlptLevel.add(jlptLevel);
    }
    setState(() {
      _selectedJlptLevel = _selectedJlptLevel;
    });
  }

  void _toggleKnowledgeLevel(KnowledgeLevel knowledgeLevel) {
    if (_selectedKnowledgeLevel.contains(knowledgeLevel)) {
      _selectedKnowledgeLevel.remove(knowledgeLevel);
    } else {
      _selectedKnowledgeLevel.add(knowledgeLevel);
    }
    setState(() {
      _selectedKnowledgeLevel = _selectedKnowledgeLevel;
    });
  }


  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    const titlePadding = EdgeInsets.symmetric(horizontal: 20);
    const checkboxPadding = EdgeInsets.symmetric(horizontal: 40);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            widget.filterGlossary();
          },
        ),
        title: Text(l10n.glossary_filter_by_title),
      ),
      body: Column(
        children: [
          const Row(children: [
            Padding(
              padding: titlePadding,
              child: Text(
                "JLPT Level",
                textAlign: TextAlign.left,
              ),
            ),
          ]),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Level 1"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedJlptLevel.contains(JLPTLevel.level1),
                    onChanged: (_) => {_toggleJLPTLevel(JLPTLevel.level1)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Level 2"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedJlptLevel.contains(JLPTLevel.level2),
                    onChanged: (_) => {_toggleJLPTLevel(JLPTLevel.level2)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Level 3"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedJlptLevel.contains(JLPTLevel.level3),
                    onChanged: (_) => {_toggleJLPTLevel(JLPTLevel.level3)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Level 4"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedJlptLevel.contains(JLPTLevel.level4),
                    onChanged: (_) => {_toggleJLPTLevel(JLPTLevel.level4)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Level 5"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedJlptLevel.contains(JLPTLevel.level5),
                    onChanged: (_) => {_toggleJLPTLevel(JLPTLevel.level5)}),
              ),
            ],
          ),
          const Row(children: [
            Padding(
              padding: titlePadding,
              child: Text(
                "Knowledge Level",
                textAlign: TextAlign.left,
              ),
            ),
          ]),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Learned"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value:
                    _selectedKnowledgeLevel.contains(KnowledgeLevel.learned),
                    onChanged: (_) =>
                    {_toggleKnowledgeLevel(KnowledgeLevel.learned)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Practicing"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedKnowledgeLevel
                        .contains(KnowledgeLevel.practicing),
                    onChanged: (_) =>
                    {_toggleKnowledgeLevel(KnowledgeLevel.practicing)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Seen"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedKnowledgeLevel.contains(KnowledgeLevel.seen),
                    onChanged: (_) =>
                    {_toggleKnowledgeLevel(KnowledgeLevel.seen)}),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 9,
                child: Padding(
                  padding: checkboxPadding,
                  child: Text("Never seen"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: _selectedKnowledgeLevel
                        .contains(KnowledgeLevel.neverSeen),
                    onChanged: (_) =>
                    {_toggleKnowledgeLevel(KnowledgeLevel.neverSeen)}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}