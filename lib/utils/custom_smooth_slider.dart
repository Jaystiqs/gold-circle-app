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

  void _handlePanStart(DragStartDetails details, Size size) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    _isDragging = true;
    _animationController.forward();

    // Determine which thumb is closer
    final double trackWidth = size.width - (widget.thumbRadius * 2);
    final double startPosition = _getThumbPosition(_valuesNotifier.value.start, trackWidth);
    final double endPosition = _getThumbPosition(_valuesNotifier.value.end, trackWidth);

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

    final double newValue = widget.min + (normalizedPosition * (widget.max - widget.min));

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

  double _getThumbPosition(double value, double trackWidth) {
    final double normalizedValue = (value - widget.min) / (widget.max - widget.min);
    return normalizedValue * trackWidth;
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
  });

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

    // Calculate thumb positions
    final double startPosition = trackStartX + _getThumbPosition(values.start, trackWidth);
    final double endPosition = trackStartX + _getThumbPosition(values.end, trackWidth);

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

  double _getThumbPosition(double value, double trackWidth) {
    final double normalizedValue = (value - min) / (max - min);
    return normalizedValue * trackWidth;
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
    return 'GH₵${this.round()}';
  }
}