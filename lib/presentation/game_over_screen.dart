import 'package:asteroids_game/presentation/button.dart';
import 'package:asteroids_game/presentation/game_screen.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final String timer;
  const GameOverScreen({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "GAME OVER",
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "You lasted $timer",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            ActionButton(
                label: "Try Again",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                }),
          ],
        ),
      ),
    ));
  }
}
