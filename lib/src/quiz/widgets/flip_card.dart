import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget front;

  final Widget back;

  final bool flipped;

  final bool showShadow;

  final bool allowFlip;

  const FlipCard(
      {super.key,
      required this.front,
      required this.back,
      this.flipped = false,
      this.allowFlip = false,
      this.showShadow = false});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _flipped = widget.flipped;
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipped != widget.flipped) {
      setState(() {
        _flipped = widget.flipped;
      });
    }
  }

  onTap() {
    if (widget.allowFlip) {
      setState(() {
        _flipped = !_flipped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBackgroundColor = Theme.of(context).cardTheme.color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (child, list) => Stack(children: [child!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: _build(_flipped ? widget.back : widget.front,
            MediaQuery.of(context).size.width * 0.5, cardBackgroundColor),
      ),
    );
  }

  Widget _build(Widget child, double size, Color? backgroundColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: ValueKey(_flipped),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
        boxShadow: [
          if (widget.showShadow)
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
            ),
        ],
      ),
      child: Card(
        key: ValueKey(_flipped),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Center(child: child)),
      ),
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotationAnimation = Tween(begin: pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotationAnimation,
      child: widget,
      builder: (context, child) {
        final isUnder = (ValueKey(_flipped) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? min(rotationAnimation.value, pi / 2)
            : rotationAnimation.value;

        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
