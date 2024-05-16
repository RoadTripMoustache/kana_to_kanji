import "package:flutter/material.dart";

class WrappedList extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsets padding;

  const WrappedList(
      {required this.children, super.key,
      this.padding = const EdgeInsets.only(right: 8.0)});

  @override
  Widget build(BuildContext context) => Wrap(
      children: children
          .map((item) => Padding(
                padding: padding,
                child: item,
              ))
          .toList(growable: false));
}
