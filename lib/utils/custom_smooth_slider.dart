import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmoothRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Color thumbBorderColor;
  final double thumbRadius;
  final double thumbBorderWidth;
  final double trackHeight;
  final bool useNonLinearScale;
  final double scalePower;

  const SmoothRangeSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.values,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.thumbBorderColor = Colors.blue,
    this.thumbRadius = 12.0,
    this.thumbBorderWidth = 2.0,
    this.trackHeight = 4.0,
    this.useNonLinearScale = false,
    this.scalePower = 2.0,
  }) : super(key: key);

  @override
  State<SmoothRangeSlider> createState() => _SmoothRangeSliderState();
}

class _SmoothRangeSliderState extends State<SmoothRangeSlider>
    with TickerProviderStateMixin {
  late ValueNotifier<RangeValues> _valuesNotifier;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int? _activeThumb; // 0 for start, 1 for end
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _valuesNotifier = ValueNotifier(widget.values);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(SmoothRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _valuesNotifier.value = widget.values;
    }
  }

  @override
  void dispose() {
    _valuesNotifier.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Convert normalized position (0-1) to actual value with non-linear scaling
  double _positionToValue(double normalizedPosition) {
    if (!widget.useNonLinearScale) {
      return widget.min + (normalizedPosition * (widget.max - widget.min));
    }

    // Apply power function for non-linear scaling
    // Lower values get more space, higher values get compressed
    final double scaledPosition = math.pow(normalizedPosition, widget.scalePower).toDouble();
    return widget.min + (scaledPosition * (widget.max - widget.min));
  }

  // Convert actual value to normalized position (0-1) with non-linear scaling
  double _valueToPosition(double value) {
    if (!widget.useNonLinearScale) {
      return (value - widget.min) / (widget.max - widget.min);
    }

    // Reverse of the power function
    final double normalizedValue = (value - widget.min) / (widget.max - widget.min);
    return math.pow(normalizedValue, 1.0 / widget.scalePower).toDouble();
  }

  void _handlePanStart(DragStartDetails details, Size size) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    _isDragging = true;
    _animationController.forward();

    // Determine which thumb is closer
    final double trackWidth = size.width - (widget.thumbRadius * 2);
    final double startPosition = _valueToPosition(_valuesNotifier.value.start) * trackWidth;
    final double endPosition = _valueToPosition(_valuesNotifier.value.end) * trackWidth;

    final double tapPosition = localPosition.dx - widget.thumbRadius;
    final double distanceToStart = (tapPosition - startPosition).abs();
    final double distanceToEnd = (tapPosition - endPosition).abs();

    _activeThumb = distanceToStart <= distanceToEnd ? 0 : 1;

    widget.onChangeStart?.call(_valuesNotifier.value);
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    if (!_isDragging || _activeThumb == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    final double trackWidth = size.width - (widget.thumbRadius * 2);
    final double normalizedPosition = ((localPosition.dx - widget.thumbRadius) / trackWidth)
        .clamp(0.0, 1.0);

    final double newValue = _positionToValue(normalizedPosition);

    RangeValues newValues;
    if (_activeThumb == 0) {
      // Moving start thumb
      newValues = RangeValues(
        math.min(newValue, _valuesNotifier.value.end),
        _valuesNotifier.value.end,
      );
    } else {
      // Moving end thumb
      newValues = RangeValues(
        _valuesNotifier.value.start,
        math.max(newValue, _valuesNotifier.value.start),
      );
    }

    _valuesNotifier.value = newValues;
    widget.onChanged?.call(newValues);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;
    _activeThumb = null;
    _animationController.reverse();

    widget.onChangeEnd?.call(_valuesNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = Size(constraints.maxWidth, widget.thumbRadius * 2 + 10);

        return GestureDetector(
          onPanStart: (details) => _handlePanStart(details, size),
          onPanUpdate: (details) => _handlePanUpdate(details, size),
          onPanEnd: _handlePanEnd,
          child: Container(
            width: size.width,
            height: size.height,
            child: ValueListenableBuilder<RangeValues>(
              valueListenable: _valuesNotifier,
              builder: (context, values, child) {
                return AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: size,
                      painter: _RangeSliderPainter(
                        values: values,
                        min: widget.min,
                        max: widget.max,
                        activeColor: widget.activeColor,
                        inactiveColor: widget.inactiveColor,
                        thumbColor: widget.thumbColor,
                        thumbBorderColor: widget.thumbBorderColor,
                        thumbRadius: widget.thumbRadius,
                        thumbBorderWidth: widget.thumbBorderWidth,
                        trackHeight: widget.trackHeight,
                        activeThumb: _activeThumb,
                        thumbScale: _isDragging ? _scaleAnimation.value : 1.0,
                        useNonLinearScale: widget.useNonLinearScale,
                        scalePower: widget.scalePower,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _RangeSliderPainter extends CustomPainter {
  final RangeValues values;
  final double min;
  final double max;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Color thumbBorderColor;
  final double thumbRadius;
  final double thumbBorderWidth;
  final double trackHeight;
  final int? activeThumb;
  final double thumbScale;
  final bool useNonLinearScale;
  final double scalePower;

  _RangeSliderPainter({
    required this.values,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    required this.thumbBorderColor,
    required this.thumbRadius,
    required this.thumbBorderWidth,
    required this.trackHeight,
    this.activeThumb,
    required this.thumbScale,
    required this.useNonLinearScale,
    required this.scalePower,
  });

  double _valueToPosition(double value) {
    if (!useNonLinearScale) {
      return (value - min) / (max - min);
    }

    final double normalizedValue = (value - min) / (max - min);
    return math.pow(normalizedValue, 1.0 / scalePower).toDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..strokeWidth = trackHeight
      ..strokeCap = StrokeCap.round;

    final Paint thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    final Paint thumbBorderPaint = Paint()
      ..color = thumbBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thumbBorderWidth;

    final double trackWidth = size.width - (thumbRadius * 2);
    final double trackY = size.height / 2;
    final double trackStartX = thumbRadius;
    final double trackEndX = size.width - thumbRadius;

    // Calculate thumb positions using non-linear scale
    final double startPosition = trackStartX + (_valueToPosition(values.start) * trackWidth);
    final double endPosition = trackStartX + (_valueToPosition(values.end) * trackWidth);

    // Draw inactive track (full length)
    trackPaint.color = inactiveColor;
    canvas.drawLine(
      Offset(trackStartX, trackY),
      Offset(trackEndX, trackY),
      trackPaint,
    );

    // Draw active track (between thumbs)
    trackPaint.color = activeColor;
    canvas.drawLine(
      Offset(startPosition, trackY),
      Offset(endPosition, trackY),
      trackPaint,
    );

    // Draw thumbs with scale animation
    _drawThumb(
      canvas,
      Offset(startPosition, trackY),
      thumbPaint,
      thumbBorderPaint,
      activeThumb == 0 ? thumbScale : 1.0,
    );

    _drawThumb(
      canvas,
      Offset(endPosition, trackY),
      thumbPaint,
      thumbBorderPaint,
      activeThumb == 1 ? thumbScale : 1.0,
    );
  }

  void _drawThumb(Canvas canvas, Offset center, Paint fillPaint, Paint borderPaint, double scale) {
    final double scaledRadius = thumbRadius * scale;

    // Draw subtle shadow
    canvas.drawCircle(
      center + const Offset(0, 1),
      scaledRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Draw thumb fill
    canvas.drawCircle(center, scaledRadius, fillPaint);

    // Draw thumb border
    canvas.drawCircle(center, scaledRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _RangeSliderPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.activeThumb != activeThumb ||
        oldDelegate.thumbScale != thumbScale;
  }
}

// Extension for easy formatting
extension CurrencyFormat on double {
  String toCurrency() {
    return 'GHS${this.round()}';
  }
}