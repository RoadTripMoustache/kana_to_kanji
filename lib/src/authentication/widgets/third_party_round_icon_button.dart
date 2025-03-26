import "package:flutter/material.dart";

class ThirdPartyRoundRTMIconButton extends StatelessWidget {
  /// Neutral version of the logo. The path must be an image supported
  /// by [Image.asset].
  final String? logoPath;

  /// Version of the logo to use in light theme. The path must be an image
  /// supported by [Image.asset].
  ///
  /// Ignored if [logoPath] is provided or [darkLogoPath] isn't provided.
  final String? lightLogoPath;

  /// Version of the logo to use in dark theme. The path must be an image
  /// supported by [Image.asset].
  ///
  /// Ignored if [logoPath] is provided or [lightLogoPath] isn't provided.
  final String? darkLogoPath;

  /// Function called when the button is pressed.
  final VoidCallback? onPressed;

  const ThirdPartyRoundRTMIconButton.google({this.onPressed, super.key})
    : lightLogoPath = "assets/images/logos/google_light.png",
      darkLogoPath = "assets/images/logos/google_dark.png",
      logoPath = null;

  const ThirdPartyRoundRTMIconButton.apple({this.onPressed, super.key})
    : lightLogoPath = "assets/images/logos/apple_light.png",
      darkLogoPath = "assets/images/logos/apple_dark.png",
      logoPath = null;

  @override
  Widget build(BuildContext context) {
    String imagePath = logoPath ?? lightLogoPath!;

    if (darkLogoPath != null &&
        Theme.of(context).brightness == Brightness.dark) {
      imagePath = darkLogoPath!;
    }

    return InkWell(
      key: const Key("third_party_round_icon_button"),
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
          color: onPressed == null ? Theme.of(context).disabledColor : null,
          colorBlendMode: BlendMode.dstATop,
          height: 56.0,
          width: 56.0,
        ),
      ),
    );
  }
}
