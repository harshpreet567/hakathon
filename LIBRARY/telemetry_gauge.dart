import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/constants.dart';

class TelemetryGauge extends StatelessWidget {
  final double value;
  final double max;
  final String unit;
  final Color activeColor;
  final IconData icon;

  const TelemetryGauge({
    super.key,
    required this.value,
    required this.max,
    required this.unit,
    required this.activeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (value / max).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(
                  percentage: percentage,
                  activeColor: activeColor,
                  backgroundColor: AppColors.borderDark,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: activeColor, size: size * 0.2),
                  const SizedBox(height: 4),
                  Text(
                    "${value.toStringAsFixed(1)}$unit",
                    style: TextStyle(
                      fontSize: size * 0.18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color backgroundColor;

  _GaugePainter({
    required this.percentage,
    required this.activeColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 10;
    
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

    const startAngle = 150 * (pi / 180);
    const sweepAngle = 240 * (pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * percentage,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.activeColor != activeColor;
  }
}
