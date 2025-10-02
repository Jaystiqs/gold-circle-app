import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class CircularTimelineSelector extends StatefulWidget {
  final String category; // 'Days', 'Weeks', 'Months'
  final double initialValue;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Color centerBackgroundColor;
  final double size;

  const CircularTimelineSelector({
    Key? key,
    required this.category,
    required this.initialValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeColor = const Color(0xFFE91E63),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.thumbColor = Colors.white,
    this.centerBackgroundColor = Colors.white,
    this.size = 200.0,
  }) : super(key: key);

  @override
  State<CircularTimelineSelector> createState() => _CircularTimelineSelectorState();
}

class _CircularTimelineSelectorState extends State<CircularTimelineSelector>
    with TickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isDragging = false;

  // Category-specific configurations
  Map<String, Map<String, dynamic>> get categoryConfig => {
    'Days': {
      'min': 1.0,
      'max': 30.0,
      'step': 1.0,
      'unit': 'day',
      'unitPlural': 'days',
    },
    'Weeks': {
      'min': 1.0,
      'max': 12.0,
      'step': 1.0,
      'unit': 'week',
      'unitPlural': 'weeks',
    },
    'Months': {
      'min': 1.0,
      'max': 12.0,
      'step': 1.0,
      'unit': 'month',
      'unitPlural': 'months',
    },
  };

  double get minValue => categoryConfig[widget.category]!['min'];
  double get maxValue => categoryConfig[widget.category]!['max'];
  String get unit => categoryConfig[widget.category]!['unit'];
  String get unitPlural => categoryConfig[widget.category]!['unitPlural'];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(minValue, maxValue);

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(CircularTimelineSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      // Reset value when category changes
      setState(() {
        _currentValue = math.min(widget.initialValue, maxValue).clamp(minValue, maxValue);
      });
      widget.onChanged(_currentValue);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  double get _normalizedValue {
    return (_currentValue - minValue) / (maxValue - minValue);
  }

  double _getAngleFromPosition(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final delta = position - center;
    var angle = math.atan2(delta.dy, delta.dx);

    // Normalize to 0-2π
    if (angle < 0) angle += 2 * math.pi;

    // Convert to our coordinate system (starting from top)
    angle = angle + math.pi / 2;
    if (angle > 2 * math.pi) angle -= 2 * math.pi;

    // Map to 0-1 range (using 270 degrees)
    final maxAngle = 3 * math.pi / 2;
    return math.min(angle / maxAngle, 1.0);
  }

  void _updateValue(Offset position, Size size) {
    final normalizedAngle = _getAngleFromPosition(position, size);
    final newValue = minValue + normalizedAngle * (maxValue - minValue);
    final step = categoryConfig[widget.category]!['step'] as double;
    final roundedValue = (newValue / step).round() * step;
    final clampedValue = roundedValue.clamp(minValue, maxValue).toDouble();

    if (clampedValue != _currentValue) {
      setState(() {
        _currentValue = clampedValue;
      });
      widget.onChanged(clampedValue);
      HapticFeedback.selectionClick();
    }
  }

  bool _isInThumbArea(Offset position, Size size) {
    final angle = _normalizedValue * 3 * math.pi / 2 - math.pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 40) / 2;
    final thumbPosition = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final distance = (position - thumbPosition).distance;
    return distance <= 30; // Generous hit area
  }

  String _formatValue() {
    final value = _currentValue.round();
    return value.toString();
  }

  String _formatUnit() {
    final value = _currentValue.round();
    return value == 1 ? unit : unitPlural;
  }

  String _formatDateRange() {
    final now = DateTime.now();
    late DateTime endDate;

    switch (widget.category) {
      case 'Days':
        endDate = now.add(Duration(days: _currentValue.round()));
        break;
      case 'Weeks':
        endDate = now.add(Duration(days: _currentValue.round() * 7));
        break;
      case 'Months':
        endDate = DateTime(now.year, now.month + _currentValue.round(), now.day);
        break;
    }

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    final startFormatted = '${days[now.weekday % 7]}, ${months[now.month - 1]} ${now.day}';
    final endFormatted = '${days[endDate.weekday % 7]}, ${months[endDate.month - 1]} ${endDate.day}';

    return '$startFormatted to $endFormatted';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size, // Removed the extra +60 pixels
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: GestureDetector(
          onPanStart: (details) {
            final size = Size(widget.size, widget.size);
            if (_isInThumbArea(details.localPosition, size)) {
              setState(() => _isDragging = true);
              _scaleController.forward();
              widget.onChangeStart?.call(_currentValue);
              HapticFeedback.lightImpact();
            }
          },
          onPanUpdate: (details) {
            if (_isDragging) {
              final size = Size(widget.size, widget.size);
              _updateValue(details.localPosition, size);
            }
          },
          onPanEnd: (details) {
            if (_isDragging) {
              setState(() => _isDragging = false);
              _scaleController.reverse();
              widget.onChangeEnd?.call(_currentValue);
              HapticFeedback.lightImpact();
            }
          },
          onTapDown: (details) {
            final size = Size(widget.size, widget.size);
            if (_isInThumbArea(details.localPosition, size)) {
              setState(() => _isDragging = true);
              _scaleController.forward();
              widget.onChangeStart?.call(_currentValue);
              HapticFeedback.lightImpact();
            } else {
              // Allow tapping anywhere on the circle to jump to that position
              _updateValue(details.localPosition, size);
              HapticFeedback.selectionClick();
            }
          },
          onTapUp: (details) {
            if (_isDragging) {
              setState(() => _isDragging = false);
              _scaleController.reverse();
              widget.onChangeEnd?.call(_currentValue);
              HapticFeedback.lightImpact();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // Custom paint for the circular track and thumb
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: CircularTimelinePainter(
                        value: _normalizedValue,
                        activeColor: widget.activeColor,
                        inactiveColor: widget.inactiveColor,
                        thumbColor: widget.thumbColor,
                        isDragging: _isDragging,
                        scaleValue: _scaleAnimation.value,
                      ),
                    );
                  },
                ),
              ),

              // Center content
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: widget.size * 0.45,
                    height: widget.size * 0.45,
                    decoration: BoxDecoration(
                      color: widget.centerBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: TextStyle(
                            fontSize: _isDragging ? 35 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          child: Text(_formatValue()),
                        ),
                        const SizedBox(height: 0),
                        Text(
                          _formatUnit(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CircularTimelinePainter extends CustomPainter {
  final double value;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final bool isDragging;
  final double scaleValue;

  CircularTimelinePainter({
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    required this.isDragging,
    required this.scaleValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 40) / 2;
    final strokeWidth = 6.0;
    final thumbRadius = 12.0;

    // Draw track background
    final trackPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      3 * math.pi / 2,
      false,
      trackPaint,
    );

    // Draw active progress
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = value * 3 * math.pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw thumb
    final thumbAngle = value * 3 * math.pi / 2 - math.pi / 2;
    final thumbPosition = Offset(
      center.dx + radius * math.cos(thumbAngle),
      center.dy + radius * math.sin(thumbAngle),
    );

    final currentThumbRadius = thumbRadius * scaleValue;

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      thumbPosition + const Offset(0, 2),
      currentThumbRadius,
      shadowPaint,
    );

    // Thumb background
    final thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(thumbPosition, currentThumbRadius, thumbPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = activeColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(thumbPosition, currentThumbRadius, thumbBorderPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      thumbPosition - const Offset(2, 2),
      currentThumbRadius * 0.3,
      highlightPaint,
    );

    // Progress dots
    _drawProgressDots(canvas, center, radius, size);
  }

  void _drawProgressDots(Canvas canvas, Offset center, double radius, Size size) {
    final dotPaint = Paint()
      ..color = inactiveColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i <= 8; i++) {
      final angle = (i * math.pi / 6) - math.pi / 2;
      final dotPosition = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      canvas.drawCircle(dotPosition, 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CircularTimelinePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.isDragging != isDragging ||
        oldDelegate.scaleValue != scaleValue;
  }
}