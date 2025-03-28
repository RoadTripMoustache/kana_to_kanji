import "package:flutter/material.dart";

class TileItem extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const TileItem({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: leading,
    title: title,
    subtitle: subtitle,
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    trailing: trailing,
  );
}
