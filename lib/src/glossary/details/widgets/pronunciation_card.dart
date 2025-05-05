import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/example_line.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/pronunciation_title.dart";

class PronunciationCard extends StatelessWidget {
  final String pronunciation;

  final String toBold;

  final List<String> meanings;

  final List<({String japanese, String translation})> examples;

  final double pronunciationMinWidth;

  final Future Function(String reading) onSpeakerPressed;

  const PronunciationCard({
    required this.pronunciation,
    required this.toBold,
    required this.meanings,
    required this.onSpeakerPressed,
    super.key,
    this.examples = const [],
    this.pronunciationMinWidth = 48.0,
  });

  factory PronunciationCard.fromPronunciationDetails({
    required PronunciationDetails pronunciation,
    required String toBold,
    required Future Function(String reading) onSpeakerPressed,
    double pronunciationMinWidth = 48.0,
  }) => PronunciationCard(
    pronunciation: pronunciation.reading,
    toBold: toBold,
    meanings: pronunciation.meanings,
    examples: [],
    pronunciationMinWidth: pronunciationMinWidth,
    onSpeakerPressed: onSpeakerPressed,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return RTMCard.outlined(
      clipBehavior: Clip.hardEdge,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                PronunciationTitle(
                  pronunciation: pronunciation,
                  minWidth: pronunciationMinWidth,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Wrap(
                            // spacing: 4,
                            children:
                                meanings.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final meaning = entry.value;

                                  return RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: meaning,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        if (index < meanings.length - 1)
                                          TextSpan(
                                            text: ", ",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: RTMIconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () async => onSpeakerPressed(pronunciation),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (examples.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: examples.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) => ExampleLine(
                          sentence: examples[index].japanese,
                          translation: examples[index].translation,
                          toBold: toBold,
                        ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
