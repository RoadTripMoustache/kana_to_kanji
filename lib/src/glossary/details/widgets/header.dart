import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/src/core/widgets/drag_handle.dart";

const _iconSize = 32.0;

class Header extends StatelessWidget {
  final String title;

  final Future Function()? onSpeakerPressed;

  final TextStyle? textStyle;

  const Header({
    required this.title,
    this.textStyle,
    this.onSpeakerPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? style = textStyle ?? theme.textTheme.displayMedium;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        DragHandle(),
        if (onSpeakerPressed != null)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const RTMPadding.all8(),
              child: RTMIconButton(
                onPressed: onSpeakerPressed,
                icon: const Icon(Icons.volume_up_rounded, size: _iconSize),
              ),
            ),
          ),
        Align(
          child: Padding(
            padding: const RTMPadding.vertical32(),
            child: Text(title, style: style),
          ),
        ),
      ],
    );
  }
}
