import 'package:flutter/material.dart';
import 'dart:math' as math;

class SoundRadarPainter extends CustomPainter {
  final List<RadarDot> dots;

  SoundRadarPainter({required this.dots});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // 同心圆
    final ringPaint = Paint()
      ..color = const Color(0xFFE0D8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, ringPaint);
    }

    // 十字线
    final axisPaint = Paint()
      ..color = const Color(0xFFE0D8F0)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius), axisPaint);
    canvas.drawLine(Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy), axisPaint);

    // 每个事件
    for (final d in dots) {
      final rad = (d.angle - 90) * math.pi / 180;
      final sx = center.dx + radius * 0.75 * math.cos(rad);
      final sy = center.dy + radius * 0.75 * math.sin(rad);

      // 光晕
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            d.color.withValues(alpha: 0.5),
            d.color.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(sx, sy), radius: 42));
      canvas.drawCircle(Offset(sx, sy), 42, glowPaint);

      // 圆点
      canvas.drawCircle(Offset(sx, sy), 9, Paint()..color = d.color);

      // 文字标签：贴在点旁边
      final textPainter = TextPainter(
        text: TextSpan(
          text: d.label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF3A3A5C),
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 计算标签位置，避免出圆
      double labelX = sx + 14;
      double labelY = sy - 8;
      if (labelX + textPainter.width > size.width - 8) {
        labelX = sx - textPainter.width - 14;
      }
      if (labelY < 4) labelY = 4;
      if (labelY + textPainter.height > size.height - 4) {
        labelY = size.height - textPainter.height - 4;
      }

      // 白色背景圆角框，让文字更清晰
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelX - 4,
          labelY - 2,
          textPainter.width + 8,
          textPainter.height + 4,
        ),
        const Radius.circular(6),
      );
      canvas.drawRRect(bgRect, Paint()..color = Colors.white.withValues(alpha: 0.9));

      textPainter.paint(canvas, Offset(labelX, labelY));
    }

    // 中心圆
    canvas.drawCircle(center, 18, Paint()..color = const Color(0xFFF0EAF8));
    canvas.drawCircle(center, 6, Paint()..color = const Color(0xFF9A8FB8));
  }

  @override
  bool shouldRepaint(covariant SoundRadarPainter oldDelegate) =>
      oldDelegate.dots != dots;
}

class RadarDot {
  final double angle;
  final Color color;
  final String label;

  RadarDot({required this.angle, required this.color, required this.label});
}