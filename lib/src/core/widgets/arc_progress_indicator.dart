import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const int _kAnimationDuration = 1800;
const double _kMinRadius = 150.0;

class ArcProgressIndicator extends StatefulWidget {
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

  /// The radius of the progress indicator
  ///
  /// If not provided 150.0 will be used
  final double? radius;

  /// Indicate if the percentage should be displayed at the center of the progress
  /// indicator.
  ///
  /// By default true.
  final bool showPercentage;

  /// Text that will be displayed at the center of the progress indicator.
  ///
  /// If [showPercentage] is true and this isn't null, the user could switch from
  /// one text to the other by tapping on it.
  final String? alternativeText;

  const ArcProgressIndicator(
      {super.key,
      this.radius,
      required this.value,
      this.backgroundColor,
      this.color,
      this.valueColor,
      this.semanticsLabel,
      this.semanticsValue,
      this.showPercentage = true,
      this.alternativeText});

  @override
  State<ArcProgressIndicator> createState() => _ArcProgressIndicatorState();
}

class _ArcProgressIndicatorState extends State<ArcProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showAlternativeText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: _kAnimationDuration),
        vsync: this,
        animationBehavior: AnimationBehavior.preserve)
      ..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9, curve: Curves.fastOutSlowIn),
      reverseCurve: Curves.fastOutSlowIn,
    );
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
    final l10n = AppLocalizations.of(context);
    final textStyle = Theme.of(context)
        .textTheme
        .headlineLarge
        ?.copyWith(color: _getValueColor(context));
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color backColor = widget.backgroundColor ??
        indicatorTheme.circularTrackColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final double size = widget.radius ?? _kMinRadius;

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final double animatedValue = widget.value * _animation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            _buildSemanticsWrapper(
                context: context,
                child: Container(
                    constraints: BoxConstraints(
                      minWidth: size,
                      minHeight: size,
                    ),
                    child: CustomPaint(
                      painter: _ArcProgressIndicatorPainter(
                          value: animatedValue,
                          valueColor: _getValueColor(context),
                          backgroundColor: backColor),
                    ))),
            if (widget.showPercentage)
              GestureDetector(
                onTap: widget.alternativeText != null
                    ? () {
                        setState(() {
                          _showAlternativeText = !_showAlternativeText;
                        });
                      }
                    : null,
                child: Text(
                    _showAlternativeText && widget.alternativeText != null
                        ? widget.alternativeText!
                        : l10n.percent(animatedValue),
                    style: textStyle),
              )
          ],
        );
      },
    );
  }
}

class _ArcProgressIndicatorPainter extends CustomPainter {
  static const double _kTrackerStrokeWidth = 12.0;
  static const double _kStrokeWidth = 4.0;

  static const double _startAngle = 3 * pi / 4;
  static const double _sweep = 3 * pi / 2;

  final Color backgroundColor;

  final Color valueColor;

  final double value;

  final double _arcSweep;

  _ArcProgressIndicatorPainter(
      {required this.backgroundColor,
      required this.valueColor,
      required this.value})
      : _arcSweep = clampDouble(value, 0.0, 1.0) * _sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = _kStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw background
    canvas.drawArc(Offset.zero & size, _startAngle, _sweep, false, paint);

    // Draw value
    paint
      ..color = valueColor
      ..strokeWidth = _kTrackerStrokeWidth;

    canvas.drawArc(Offset.zero & size, _startAngle, _arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_ArcProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value;
  }
}
