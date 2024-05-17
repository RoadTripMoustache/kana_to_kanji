import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "app_navigation_destination.freezed.dart";

@freezed
class AppNavigationDestination with _$AppNavigationDestination {
  const AppNavigationDestination._();

  const factory AppNavigationDestination(
      {required Widget icon,
      required String location,
      required String label,
      Widget? selectedIcon,
      Color? backgroundColor,
      String? tooltip}) = _AppNavigationDestination;

  NavigationDestination get navigationDestination => NavigationDestination(
      icon: icon, selectedIcon: selectedIcon, label: label, tooltip: tooltip);
}
