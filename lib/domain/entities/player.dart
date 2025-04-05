import 'package:flutter/material.dart';

class Player {
  Offset offset;
  double radius;
  Path shape;
  double angle;
  double speed;

  Player({
    required this.offset,
    required this.radius,
    required this.shape,
    required this.angle,
    required this.speed,
  });
}
