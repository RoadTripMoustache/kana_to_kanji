import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class LoadingTab extends StatelessWidget {
  final bool isDataReady;

  final Widget child;

  const LoadingTab({required this.isDataReady, required this.child, super.key});

  @override
  Widget build(BuildContext context) =>
      isDataReady ? child : const Center(child: RTMSpinner());
}
