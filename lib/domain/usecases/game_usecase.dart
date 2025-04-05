import 'dart:math';
import 'dart:ui';

import 'package:asteroids_game/domain/entities/asteroid.dart';

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
    if (currentAsteroid == 0) {
      //generate asteroids initially
      return List.generate(
          10,
          (_) => Asteroid(
                x: _random.nextDouble() * _screenSize.width,
                y: _random.nextDouble() * _screenSize.height,
                speedX: _random.nextDouble() * 2 - 1,
                speedY: _random.nextDouble() * 2 - 1,
                size: randomDouble(minAsteroidSize, maxAsteroidSize),
              ));
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
}

double randomDouble(double min, double max) =>
    Random().nextDouble() * (max - min) + min;
