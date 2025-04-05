import 'package:asteroids_game/domain/entities/asteroid.dart';
import 'package:asteroids_game/domain/entities/bullet.dart';
import 'package:asteroids_game/domain/entities/player.dart';
import 'package:flutter/material.dart';

class GamePainter extends CustomPainter {
  final Player player;
  final List<Asteroid> asteroids;
  final List<Bullet> bullets;

  GamePainter({
    required this.player,
    required this.asteroids,
    required this.bullets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final playerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final asteroidPaint = Paint()..color = Colors.red;

    canvas.drawCircle(player.offset, 20, playerPaint);

    for (final asteroid in asteroids) {
      canvas.drawCircle(
          Offset(asteroid.x, asteroid.y), asteroid.size, asteroidPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
