import 'package:flutter/material.dart';

enum Environment { dev, beta, prod }

class AppConfig extends InheritedWidget {
  final Environment environment;

  const AppConfig({
    Key? key,
    required Widget child,
    required this.environment,
  }) : super(
          key: key,
          child: child,
        );

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
