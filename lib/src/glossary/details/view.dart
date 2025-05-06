import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/details/view_model.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/header.dart";
import "package:stacked/stacked.dart";

const _maxSheetHeight = 0.99;
const _minInitialSheetHeight = 0.40;
const _minSheetHeight = 0.40;

class DetailsView extends StatelessWidget {
  final dynamic item;

  const DetailsView({required this.item, super.key})
    : assert(
        item is Kana || item is Kanji || item is Vocabulary,
        "must provide a Kana, Kanji, or Vocabulary",
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ViewModelBuilder<DetailsViewModel>.nonReactive(
      viewModelBuilder: () => DetailsViewModel(item),
      builder: (BuildContext context, DetailsViewModel viewModel, _) {
        final double initialChildSize =
            viewModel.pronunciations.length > 2 ? 0.6 : _minInitialSheetHeight;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize,
          maxChildSize: _maxSheetHeight,
          minChildSize: _minSheetHeight,
          builder: (context, scrollController) {
            late final Widget? cardBody;
            late final TextStyle? headerStyle;

            if (viewModel.isKana) {
              cardBody = null;
              headerStyle = theme.textTheme.displayLarge?.copyWith(
                fontSize: 80,
              );
            } else {
              headerStyle = theme.textTheme.displayMedium;
              cardBody = Details(
                scrollController: scrollController,
                pronunciations: viewModel.pronunciations,
                toBold: viewModel.title,
                onSpeakerPressed: viewModel.onSpeakerPressed,
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.isKana)
                  Expanded(
                    child: Header(
                      title: viewModel.title,
                      subtitle: (viewModel.item as Kana).romaji,
                      textStyle: headerStyle,
                      onSpeakerPressed: viewModel.onSpeakerPressed,
                    ),
                  )
                else
                  Header(title: viewModel.title, textStyle: headerStyle),
                if (cardBody != null)
                  Expanded(
                    child: ColoredBox(
                      color: theme.scaffoldBackgroundColor,
                      child: Padding(
                        padding: const RTMPadding.horizontal16().add(
                          EdgeInsets.only(bottom: 16),
                        ),
                        child: cardBody,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
