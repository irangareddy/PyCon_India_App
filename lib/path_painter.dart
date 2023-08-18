import 'package:flutter/material.dart';
import 'package:path_animator/path_animator.dart';

class PathPainter extends CustomPainter {
  PathPainter({
    required this.points,
    required this.controller,
  });
  final List<Offset> points;
  final AnimationController controller;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    final animatedPath = PathAnimator.build(
      path: path,
      animationPercent: controller.value,
    );

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
