import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/details/details_view_model.dart';
import 'package:kana_to_kanji/src/glossary/glossary_view.dart';
import 'package:stacked/stacked.dart';

class DetailsView extends StatelessWidget {
  static const routeName = "${GlossaryView.routeName}/details/:type/:id";
  static const _baseRouteName = "${GlossaryView.routeName}/details";

  static routeKanaName(int id) => "$_baseRouteName/kana/$id";

  static routeKanjiName(int id) => "$_baseRouteName/kanji/$id";

  static routeVocabularyName(int id) => "$_baseRouteName/vocabulary/$id";

  final dynamic item;

  const DetailsView({super.key, required this.item})
      : assert(item is Kana || item is Kanji || item is Vocabulary);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailsViewModel>.nonReactive(
        viewModelBuilder: () => DetailsViewModel(item),
        builder: (BuildContext context, DetailsViewModel viewModel, _) {
          final AppLocalizations l10n = AppLocalizations.of(context);

          return AppScaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            minimumHorizontalPadding: 0.0,
            body: Column(
              children: [
                Center(
                  child: Text(
                    viewModel.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
