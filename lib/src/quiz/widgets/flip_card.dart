import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget front;

  final Widget back;

  final bool flipped;

  final bool allowFlip;

  const FlipCard(
      {super.key,
      required this.front,
      required this.back,
      this.flipped = false,
      this.allowFlip = false});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  final Duration _animationDuration = const Duration(milliseconds: 800);

  bool _flipped = false;

  late Widget _front;
  late Widget _back;

  @override
  void initState() {
    super.initState();
    _flipped = widget.flipped;
    _front = widget.front;
    _back = widget.back;
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool newFlipped = _flipped;
    Widget newFront = _front;
    Widget newBack = _back;

    if (oldWidget.flipped != widget.flipped) {
      newFlipped = !_flipped;
    }

    if (oldWidget.front.key != widget.front.key ||
        oldWidget.back.key != widget.back.key) {
      newFront = widget.front;
      newBack = widget.back;
      newFlipped = !_flipped;

      if (!_flipped) {
        newBack = widget.front;
        newFront = _front;
        Future.delayed(_animationDuration, () {
          setState(() {
            _front = widget.back;
          });
        });
      }
    }

    setState(() {
      _flipped = newFlipped;
      _front = newFront;
      _back = newBack;
    });
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
        duration: _animationDuration,
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (child, list) => Stack(children: [child!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: _build(_flipped ? _back : _front,
            MediaQuery.of(context).size.width * 0.5, cardBackgroundColor),
      ),
    );
  }

  Widget _build(Widget child, double size, Color? backgroundColor) {
    return Container(
      key: ValueKey(_flipped),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Card(
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
