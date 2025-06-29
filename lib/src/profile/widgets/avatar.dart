import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class Avatar extends StatelessWidget {
  final String? svg;

  final VoidCallback? onTap;

  const Avatar({super.key, this.svg, this.onTap});

  @override
  Widget build(BuildContext context) =>
      InkWell(onTap: onTap, child: SvgPicture.string(svg!, fit: BoxFit.cover));
}
