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
