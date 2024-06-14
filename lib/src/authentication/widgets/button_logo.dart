import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class ButtonLogo extends StatelessWidget {
  final String logoPath;
  final void Function()? onPressedFunction;

  const ButtonLogo(
      {required this.logoPath, required this.onPressedFunction, super.key});

  const ButtonLogo.google({required this.onPressedFunction, super.key})
      : logoPath = "assets/images/logos/google_web_light_rd.svg";

  const ButtonLogo.apple({required this.onPressedFunction, super.key})
      : logoPath = "assets/images/logos/apple_light.svg";

  @override
  Widget build(BuildContext context) => ElevatedButton(
        key: const Key("button_logo_widget"),
        onPressed: onPressedFunction,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(),
        ),
        child: SvgPicture.asset(
          logoPath,
          height: 56.0,
        ),
      );
}
