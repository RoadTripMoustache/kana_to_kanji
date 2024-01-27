import 'package:flutter/material.dart';

enum Environment { dev, beta, prod }

class AppConfig extends InheritedWidget {
  final Environment environment;

  const AppConfig({
    super.key,
    required super.child,
    required this.environment,
  });

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
