import 'package:flutter/material.dart';

class WrappedList extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsets padding;

  const WrappedList(
      {super.key,
      required this.children,
      this.padding = const EdgeInsets.only(right: 8.0)});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: children
            .map((item) => Padding(
                  padding: padding,
                  child: item,
                ))
            .toList(growable: false));
  }
}
