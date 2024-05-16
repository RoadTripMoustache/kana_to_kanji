import "package:flutter/material.dart";

enum Environment { dev, beta, prod }

class AppConfig extends InheritedWidget {
  final Environment environment;

  const AppConfig({
    required super.child,
    required this.environment,
    super.key,
  });

  static AppConfig of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConfig>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
