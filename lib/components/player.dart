import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/main.dart';

class Player extends SpriteComponent with HasGameRef<SpaceInvaders>, KeyboardHandler {
  
  // Movement properties
  static const double maxSpeed = 200.0;
  Vector2 velocity = Vector2.zero();

  // Playing field properties
  static late final double maxMoveLeft;
  static late final double maxMoveRight;
  
  Player () : super ( // Initialize parent's required parameters.
    size: Vector2.all(32),
    anchor: Anchor.center,
  );
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - size.y / 2); // Bottom center of screen

    maxMoveLeft = size.x / 2;
    maxMoveRight = gameRef.size.x - size.x / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (velocity != Vector2.zero()) {
      position += velocity * dt;
      position.x = clampDouble(position.x, maxMoveLeft, maxMoveRight);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        velocity.x = -maxSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = maxSpeed;
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = 0;
      }
    }
    
    return true; // Allow arrow events to other components
  }
}