import 'dart:math';
import 'dart:ui';

import 'package:asteroids_game/domain/entities/asteroid.dart';
import 'package:asteroids_game/domain/entities/bullet.dart';
import 'package:asteroids_game/domain/entities/player.dart';
import 'package:asteroids_game/utils.dart';

class GameUsecase {
  final Random _random = Random();
  late Size _screenSize;
  late DateTime gameStartTime;
  late DateTime gameCurrentTime;
  late double minAsteroidSize;
  late double maxAsteroidSize;

  void setScreenSize(Size size) {
    _screenSize = size;
  }

  List<Asteroid>? generateAsteroids(int currentAsteroid) {
    if (currentAsteroid < 4) {
      //generate asteroids initially
      return List.generate(10, (_) {
        double asteroidRadius = randomDouble(minAsteroidSize, maxAsteroidSize);
        return Asteroid(
            x: _random.nextDouble() * _screenSize.width,
            y: _random.nextDouble() * _screenSize.height,
            speedX: _random.nextDouble() * 2 - 1,
            speedY: _random.nextDouble() * 2 - 1,
            size: asteroidRadius,
            shape: _generateRandomAsteroidShape(asteroidRadius));
      });
    }
    return [];
  }

  void updateAsteroids(List<Asteroid> asteroids) {
    for (var asteroid in asteroids) {
      asteroid.x += asteroid.speedX;
      asteroid.y += asteroid.speedY;

      if (asteroid.x < 0) asteroid.x = _screenSize.width;
      if (asteroid.x > _screenSize.width) asteroid.x = 0;
      if (asteroid.y < 0) asteroid.y = _screenSize.height;
      if (asteroid.y > _screenSize.height) asteroid.y = 0;
    }
  }

  bool detectPlayerAsteroidCollision(Player player, List<Asteroid> asteroids) {
    for (var asteroid in asteroids) {
      if (_checkPathCollision(player.shape, player.offset, asteroid.shape,
          Offset(asteroid.x, asteroid.y))) {
        return true;
      }
    }
    return false;
  }

  bool _checkPathCollision(
      Path path1, Offset offset1, Path path2, Offset offset2) {
    final bounds1 = path1.getBounds().shift(offset1);
    final bounds2 = path2.getBounds().shift(offset2);
    return bounds1.overlaps(bounds2);
  }

  void updatePlayer(Player player, double rotationSpeed, double acceleration,
      double friction) {
    final newOffsetX = player.offset.dx + player.speed * cos(player.angle);
    final newOffsetY = player.offset.dy + player.speed * sin(player.angle);

    player.offset = Offset(newOffsetX, newOffsetY); // Update offset

    player.speed *= friction;

    if (player.offset.dx < 0) {
      player.offset = Offset(_screenSize.width, player.offset.dy);
    }
    if (player.offset.dx > _screenSize.width) {
      player.offset = Offset(0, player.offset.dy);
    }
    if (player.offset.dy < 0) {
      player.offset = Offset(player.offset.dx, _screenSize.height);
    }
    if (player.offset.dy > _screenSize.height) {
      player.offset = Offset(player.offset.dx, 0);
    }

    player.shape = createPlayerShape(player.angle);
  }

  Bullet createBullet(Player player, double bulletSpeed) {
    return Bullet(
      x: player.offset.dx,
      y: player.offset.dy,
      speedX: bulletSpeed * cos(player.angle),
      speedY: bulletSpeed * sin(player.angle),
    );
  }

  void updateBullets(List<Bullet> bullets) {
    for (int i = bullets.length - 1; i >= 0; i--) {
      bullets[i].x += bullets[i].speedX;
      bullets[i].y += bullets[i].speedY;

      if (bullets[i].x < 0 ||
          bullets[i].x > _screenSize.width ||
          bullets[i].y < 0 ||
          bullets[i].y > _screenSize.height) {
        bullets.removeAt(i);
      }
    }
  }

  void detectBulletAsteroidCollision(
      List<Bullet> bullets, List<Asteroid> asteroids) {
    for (int i = asteroids.length - 1; i >= 0; i--) {
      for (int j = bullets.length - 1; j >= 0; j--) {
        if (_checkCirclePathCollision(
            Offset(bullets[j].x, bullets[j].y),
            bullets[j].radius,
            asteroids[i].shape,
            Offset(asteroids[i].x, asteroids[i].y))) {
          asteroids.removeAt(i);
          bullets.removeAt(j);
          return;
        }
      }
    }
  }

  bool _checkCirclePathCollision(
      Offset circleCenter, double circleRadius, Path path, Offset pathOffset) {
    final bounds = path.getBounds().shift(pathOffset);
    final circleBounds =
        Rect.fromCircle(center: circleCenter, radius: circleRadius);
    return bounds.overlaps(circleBounds);
  }

  Path _generateRandomAsteroidShape(double size) {
    final path = Path();
    final numPoints = _random.nextInt(8) + 5;
    for (int i = 0; i < numPoints; i++) {
      final angle = 2 * pi * i / numPoints;
      final radiusVariation = _random.nextDouble() * size * 0.8;
      final radius = size + radiusVariation * (_random.nextDouble() * 2 - 1);
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
}

double randomDouble(double min, double max) =>
    Random().nextDouble() * (max - min) + min;
