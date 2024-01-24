import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/details/details_view_model.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/details.dart';
import 'package:stacked/stacked.dart';

class DetailsView extends StatelessWidget {
  final dynamic item;

  const DetailsView({super.key, required this.item})
      : assert(item is Kana || item is Kanji || item is Vocabulary);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailsViewModel>.nonReactive(
        viewModelBuilder: () => DetailsViewModel(item),
        builder: (BuildContext context, DetailsViewModel viewModel, _) {
          final AppLocalizations l10n = AppLocalizations.of(context);
          late final Widget cardBody;

          switch (item) {
            case Kana _:
              cardBody = Details.kana(kana: item);
              break;
            case Kanji _:
              cardBody = Details.kanji(kanji: item);
              break;
            case Vocabulary _:
              cardBody = Details.vocabulary(vocabulary: item);
              break;
          }

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:  Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Center(
                      child: Text(
                        viewModel.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(child: cardBody))))
              ],
            ),
          );
        });
  }
}
