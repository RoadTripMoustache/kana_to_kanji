import "package:flutter/material.dart";

class BadgeIcon extends StatelessWidget {
  final Widget icon;

  final bool showBadge;

  const BadgeIcon({required this.icon, super.key, this.showBadge = false});

  @override
  Widget build(BuildContext context) => Badge(
    isLabelVisible: showBadge,
    backgroundColor: Colors.deepOrange,
    child: icon,
  );
}
