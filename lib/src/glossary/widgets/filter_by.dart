import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_levels.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';

class FilterBy extends StatefulWidget {
  final VoidCallback filterGlossary;
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

  void _clearLists() {
    _selectedKnowledgeLevel.clear();
    _selectedJlptLevel.clear();
    setState(() {
      _selectedKnowledgeLevel = _selectedKnowledgeLevel;
      _selectedJlptLevel = _selectedJlptLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    const titlePadding = EdgeInsets.only(left: 20, top: 8, right: 20);

    const styleTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              _clearLists();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(children: [
            Padding(
              padding: titlePadding,
              child: Text(
                l10n.jlpt_level_title,
                textAlign: TextAlign.left,
                style: styleTitle,
              ),
            ),
          ]),
          for (var jlpt in JLPTLevel.values)
            CheckboxListTile(
                visualDensity: VisualDensity.compact,
                title: Text(l10n.jlpt_level_short(jlpt.value)),
                value: _selectedJlptLevel.contains(jlpt),
                onChanged: (_) => {_toggleJLPTLevel(jlpt)}),
          Row(children: [
            Padding(
              padding: titlePadding,
              child: Text(
                l10n.knowledge_level_title,
                textAlign: TextAlign.left,
                style: styleTitle,
              ),
            ),
          ]),
          for (var knowledgeLevel in KnowledgeLevel.values)
            CheckboxListTile(
                visualDensity: VisualDensity.compact,
                title: Text(l10n.knowledge_level(knowledgeLevel.name)),
                value: _selectedKnowledgeLevel.contains(knowledgeLevel),
                onChanged: (_) => {_toggleKnowledgeLevel(knowledgeLevel)}),
        ],
      ),
    );
  }
}
