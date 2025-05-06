import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/src/core/widgets/drag_handle.dart";

const _iconSize = 32.0;

class Header extends StatelessWidget {
  final String title;

  final String? subtitle;

  final Future Function()? onSpeakerPressed;

  final TextStyle? textStyle;

  const Header({
    required this.title,
    this.subtitle,
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
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const RTMPadding.vertical32(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: style),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(subtitle!, style: theme.textTheme.titleLarge),
                if (onSpeakerPressed != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: RTMIconButton(
                      onPressed: onSpeakerPressed,
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        size: _iconSize,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
