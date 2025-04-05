import 'package:flutter/material.dart';

class Asteroid {
  double x;
  double y;
  double speedX;
  double speedY;
  double size;
  Path shape;

  Asteroid({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.shape,
  });
}
