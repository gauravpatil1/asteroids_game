import 'dart:async';

import 'package:asteroids_game/domain/entities/asteroid.dart';
import 'package:asteroids_game/domain/entities/bullet.dart';
import 'package:asteroids_game/domain/entities/player.dart';
import 'package:asteroids_game/domain/usecases/game_usecase.dart';
import 'package:asteroids_game/presentation/game_painter.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Player _player = Player(offset: Offset(100, 100));
  final List<Asteroid> _asteroids = [];
  final List<Bullet> _bullets = [];

  Timer? _timer;
  int _elapsedSecondsInGame = 0;

  final GameUsecase _gameUsecase = GameUsecase();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  _startGame() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSecondsInGame++;
      });
    });
  }

  _endGame() {}

  String _formattedTime() {
    final minutes = (_elapsedSecondsInGame ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSecondsInGame % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
              child: Text('Timer: ${_formattedTime()}',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    ));
  }
}
