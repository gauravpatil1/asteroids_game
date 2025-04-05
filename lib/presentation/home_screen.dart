import 'package:asteroids_game/presentation/button.dart';
import 'package:asteroids_game/presentation/game_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ActionButton(
            label: "Start Game",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            }),
      ),
    ));
  }
}
