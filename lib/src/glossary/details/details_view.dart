import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/details/details_view_model.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/details.dart';
import 'package:stacked/stacked.dart';

/// Minimum percentage of the height of the screen allowed for Kana.
const _minHeightKana = 0.30;

/// Minimum percentage of the height of the screen allowed by default.
const _minHeightDefault = 0.40;

class DetailsView extends StatelessWidget {
  final dynamic item;

  const DetailsView({super.key, required this.item})
      : assert(item is Kana || item is Kanji || item is Vocabulary);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailsViewModel>.nonReactive(
        viewModelBuilder: () => DetailsViewModel(item),
        builder: (BuildContext context, DetailsViewModel viewModel, _) {
          late final Widget cardBody;
          double minHeight =
              MediaQuery.of(context).size.height * _minHeightDefault;

          switch (item) {
            case Kana _:
              cardBody = Details.kana(
                  kana: item,
                  onPronunciationsPressed: viewModel.onPronunciationPressed);
              minHeight = MediaQuery.of(context).size.height * _minHeightKana;
              break;
            case Kanji _:
              cardBody = Details.kanji(
                  kanji: item,
                  onPronunciationsPressed: viewModel.onPronunciationPressed);
              break;
            case Vocabulary _:
              cardBody = Details.vocabulary(
                  vocabulary: item,
                  onPronunciationsPressed: viewModel.onPronunciationPressed);
              break;
          }

          return Container(
            constraints: BoxConstraints(minHeight: minHeight),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppTheme.getModalBottomSheetBackgroundColor(
                      Theme.of(context)),
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
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(child: cardBody))
              ],
            ),
          );
        });
  }
}
