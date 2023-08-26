import 'package:flutter/material.dart';

const int _kAnimationDuration = 300;
const double _kMinHeight = 12.0;

class RoundedLinearProgressIndicator extends StatefulWidget {
  /// The value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  final double value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color? backgroundColor;

  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [ProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  final String? semanticsValue;

  /// The height of the progress indicator
  ///
  /// If not provided 12.0 will be used
  final double? height;

  const RoundedLinearProgressIndicator(
      {super.key,
      this.height,
      required this.value,
      this.backgroundColor,
      this.color,
      this.valueColor,
      this.semanticsLabel,
      this.semanticsValue});

  @override
  State<RoundedLinearProgressIndicator> createState() =>
      _RoundedLinearProgressIndicatorState();
}

class _RoundedLinearProgressIndicatorState
    extends State<RoundedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration =
      Duration(milliseconds: _kAnimationDuration);

  late AnimationController _controller;
  late Animation<double> _animation;

  double _currentBegin = 0;
  double _currentEnd = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: _animationDuration,
        vsync: this,
        animationBehavior: AnimationBehavior.preserve);

    _animation = Tween<double>(begin: _currentBegin, end: _currentEnd)
        .animate(_controller);

    _triggerAnimation();
  }

  @override
  void didUpdateWidget(RoundedLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() {
    setState(() {
      _currentBegin = _animation.value;
      _currentEnd = widget.value / 1;

      _animation = Tween<double>(begin: _currentBegin, end: _currentEnd)
          .animate(_controller);
    });
    _controller.reset();
    _controller.duration = _animationDuration;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getValueColor(BuildContext context, {Color? defaultColor}) {
    return widget.valueColor?.value ??
        widget.color ??
        ProgressIndicatorTheme.of(context).color ??
        defaultColor ??
        Theme.of(context).colorScheme.primary;
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String expandedSemanticsValue =
        widget.semanticsValue ?? '${(widget.value * 100).round()}%';

    return Semantics(
      label: widget.semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color backColor = widget.backgroundColor ??
        indicatorTheme.circularTrackColor ??
        Theme.of(context).colorScheme.surfaceVariant;
    final double height = widget.height ?? _kMinHeight;

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final double animatedValue = _animation.value;

        return _buildSemanticsWrapper(
            context: context,
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                ),
                child: CustomPaint(
                  painter: _RoundedLinearIndicatorPainter(
                      value: animatedValue,
                      valueColor: _getValueColor(context),
                      backgroundColor: backColor),
                )));
      },
    );
  }
}

class _RoundedLinearIndicatorPainter extends CustomPainter {
  static const double _kTrackerStrokeWidth = 12.0;
  static const double _kStrokeWidth = 4.0;

  final Color backgroundColor;

  final Color valueColor;

  final double value;

  _RoundedLinearIndicatorPainter(
      {required this.backgroundColor,
      required this.valueColor,
      required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = _kStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double center = size.height / 2;
    final Offset start = Offset(0, center);

    // Draw background
    canvas.drawLine(start, Offset(size.width, center), paint);

    // Draw value
    paint
      ..color = valueColor
      ..strokeWidth = _kTrackerStrokeWidth;

    canvas.drawLine(start, Offset(size.width * value, center), paint);
  }

  @override
  bool shouldRepaint(_RoundedLinearIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value;
  }
}
