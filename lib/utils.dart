import 'dart:math';

import 'package:flutter/material.dart';

Path createCirclePath(double radius, {int segments = 32}) {
  final path = Path();
  for (int i = 0; i <= segments; i++) {
    final angle = 2 * pi * i / segments;
    final x = radius * cos(angle);
    final y = radius * sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

Path createPlayerShape(double angle) {
  final path = Path();
  final length = 20.0;
  final width = 10.0;

  path.moveTo(length * cos(angle), length * sin(angle));
  path.lineTo(
      width * cos(angle + 2.0 * pi / 3.0), width * sin(angle + 2.0 * pi / 3.0));
  path.lineTo(
      width * cos(angle - 2.0 * pi / 3.0), width * sin(angle - 2.0 * pi / 3.0));
  path.close();
  return path;
}
