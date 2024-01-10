import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/pronunciation_card.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/section_title.dart';
import 'package:kana_to_kanji/src/glossary/glossary_view.dart';

class KanaDetailsView extends StatelessWidget {
  static const routeName = "${GlossaryView.routeName}/details/kana";

  final Kana kana;

  const KanaDetailsView({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      minimumHorizontalPadding: 0.0,
      body: Center(child: Text(kana.kana),),
    );
  }
}
