import 'package:asteroids_game/domain/entities/asteroid.dart';
import 'package:asteroids_game/domain/entities/bullet.dart';
import 'package:asteroids_game/domain/entities/player.dart';
import 'package:asteroids_game/domain/usecases/game_usecase.dart';
import 'package:asteroids_game/presentation/game_over_screen.dart';
import 'package:asteroids_game/presentation/game_painter.dart';
import 'package:asteroids_game/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final bulletSpeed = 10.0;
  Player _player = Player(
    offset: Offset(0, 0),
    radius: 20,
    shape: createPlayerShape(0),
    angle: 0,
    speed: 0,
  );
  final List<Asteroid> _asteroids = [];
  final List<Bullet> _bullets = [];

  final GameUsecase _gameUseCase = GameUsecase();
  late Ticker _ticker;

  final double _playerRotationSpeed = 0.1;
  final double _acceleration = 0.2;
  final double _friction = 0.99;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _player = Player(
        offset: Offset(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2),
        radius: 20,
        shape: createPlayerShape(0),
        angle: 0,
        speed: 0,
      );
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
      _gameUseCase.updatePlayer(
          _player, _playerRotationSpeed, _acceleration, _friction);
      if (_asteroids.length < 4) {
        _asteroids
            .addAll(_gameUseCase.generateAsteroids(_asteroids.length) ?? []);
      }
      _gameUseCase.updateAsteroids(_asteroids);
      _gameUseCase.updateBullets(_bullets);
      _gameUseCase.detectBulletAsteroidCollision(_bullets, _asteroids);
      bool isGameOver =
          _gameUseCase.detectPlayerAsteroidCollision(_player, _asteroids);
      if (isGameOver) {
        _ticker.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GameOverScreen(timer: gameTimer)),
        );
      }
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
        onPanUpdate: (details) {
          setState(() {
            _player.angle += details.delta.dx * _playerRotationSpeed;
            _player.shape = createPlayerShape(_player.angle);
          });
        },
        // onDoubleTap: () {
        //   setState(() {
        //     _player.speed += _acceleration;
        //   });
        // },
        onDoubleTap: () {
          setState(() {
            _bullets.add(_gameUseCase.createBullet(_player, bulletSpeed));
          });
        },
        onTap: () {
          setState(() {
            _bullets.add(_gameUseCase.createBullet(_player, bulletSpeed));
          });
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
