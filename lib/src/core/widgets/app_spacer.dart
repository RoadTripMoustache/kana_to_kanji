import 'package:flutter/material.dart';

/// Utility class to unify the spacing inside the application.
/// Follows the [rule of 8](https://fronty.com/what-is-8-point-grid-system-in-ux-design).
class AppSpacer extends StatelessWidget {
  final double height;
  final double width;

  const AppSpacer._({super.key, required this.height, required this.width});

  factory AppSpacer.p8() => const AppSpacer._(height: 8, width: 8);

  factory AppSpacer.p16() => const AppSpacer._(height: 16, width: 16);

  factory AppSpacer.p24() => const AppSpacer._(height: 24, width: 24);

  factory AppSpacer.p32() => const AppSpacer._(height: 32, width: 32);

  factory AppSpacer.p40() => const AppSpacer._(height: 40, width: 40);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
