import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:space_invaders/components/space_invaders.dart';

void main() {
  runApp(GameApp());
}


class GameApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final spaceInvadersGame = SpaceInvaders();

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: spaceInvadersGame,
              overlayBuilderMap: {
                'MainMenu': (context, SpaceInvaders spaceInvadersGame) {
                  return MainMenuOverlay(
                    onStartPressed: () {
                      spaceInvadersGame.startGame(); // Start the game
                      spaceInvadersGame.overlays.remove('MainMenu'); // Hide menu overlay
                    },
                  );
                },
              },
              initialActiveOverlays: const ['MainMenu'], // Show menu first
            ),
          ],
        ),
      ),
    );
  }
  
}

class MainMenuOverlay extends StatelessWidget {
  final VoidCallback onStartPressed;

  const MainMenuOverlay({Key? key, required this.onStartPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onStartPressed,
        child: const Text('Start Game'),
      ),
    );
  }
}