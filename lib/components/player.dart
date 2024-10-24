import 'dart:async';
import 'package:flame/components.dart';
import 'package:space_invaders/main.dart';

class Player extends SpriteComponent with HasGameRef<SpaceInvaders> {
  
  Player () : super ( // Initialize parent's required parameters.
    size: Vector2.all(32),
    anchor: Anchor.center,
  );
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player.png');

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - size.y / 2); // Bottom center of screen
  }
}