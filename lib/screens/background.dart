import 'dart:math';
import 'package:flutter/material.dart';



class Circle {
  Offset position;
  double radius;
  Color color;
  double dx;
  double dy;

  Circle({required this.position, required this.radius, required this.color, required this.dx, required this.dy});

  void move(Size size) {
    position = Offset(position.dx + dx*0.05, position.dy + dy*0.05);
    if (position.dx - radius < 0 || position.dx + radius > size.width) {
      dx = -dx;
    }
    if (position.dy - radius < 0 || position.dy + radius > size.height) {
      dy = -dy;
    }
  }
}
class CirclePainter extends CustomPainter {
  final List<Circle> circles;

  CirclePainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    for (Circle circle in circles) {
      Paint paint = Paint()..color = circle.color;
      canvas.drawCircle(circle.position, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}