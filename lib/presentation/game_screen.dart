import 'dart:async';

import 'package:asteroids_game/domain/entities/asteroid.dart';
import 'package:asteroids_game/domain/entities/bullet.dart';
import 'package:asteroids_game/domain/entities/player.dart';
import 'package:asteroids_game/domain/usecases/game_usecase.dart';
import 'package:asteroids_game/presentation/game_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final Player _player = Player(offset: Offset(0, 0));
  final List<Asteroid> _asteroids = [];
  final List<Bullet> _bullets = [];

  final GameUsecase _gameUseCase = GameUsecase();
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _player.offset = Offset(MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2);
      _gameUseCase.gameStartTime = DateTime.now();
      _gameUseCase.gameCurrentTime = DateTime.now();
      _gameUseCase.minAsteroidSize = 5.0;
      _gameUseCase.maxAsteroidSize = 50.0;
      _gameUseCase.setScreenSize(MediaQuery.of(context).size);
      _asteroids
          .addAll(_gameUseCase.generateAsteroids(_asteroids.length) ?? []);
      _ticker.start();
    });
  }

  String gameTimer = "0:0";
  int gameTimerInSeconds = 0;
  _setCurrentGameTime() {
    final difference =
        _gameUseCase.gameCurrentTime.difference(_gameUseCase.gameStartTime);
    final minutes =
        difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        difference.inSeconds.remainder(60).toString().padLeft(2, '0');
    gameTimer = '$minutes:$seconds';
    gameTimerInSeconds = difference.inSeconds;
  }

  void _tick(Duration duration) {
    setState(() {
      _gameUseCase.gameCurrentTime = DateTime.now();
      _setCurrentGameTime();
      _gameUseCase.updateAsteroids(_asteroids);
    });
  }

  void _updatePosition(PointerEvent details) {
    setState(() {
      _player.offset = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () {
          //fire the bullet
        },
        child: Listener(
          onPointerHover: _updatePosition,
          onPointerMove: _updatePosition,
          child: CustomPaint(
            painter: GamePainter(
              player: _player,
              asteroids: _asteroids,
              bullets: _bullets,
            ),
            child: Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(20),
              child: Text('Timer: $gameTimer',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    ));
  }
}
