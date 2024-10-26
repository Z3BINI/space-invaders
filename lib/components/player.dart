import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/components/bullet.dart';
import 'package:space_invaders/components/explosion.dart';
import 'package:space_invaders/components/space_invaders.dart';
import 'package:flame_audio/flame_audio.dart';

class Player extends SpriteComponent with HasGameRef<SpaceInvaders>, KeyboardHandler, CollisionCallbacks {
  
  // Movement properties
  static const double maxSpeed = 200.0;
  Vector2 velocity = Vector2.zero();

  // Playing field properties
  static late double maxMoveLeft;
  static late double maxMoveRight;

  late AudioPool shotSfxPool;
  
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
    velocity = Vector2.zero(); // Reset on death

    add(
      CircleHitbox(
        radius: width / 2,
      ),
    );

    shotSfxPool = await FlameAudio.createPool(
      'shot.mp3',
      maxPlayers: 1,
    );

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
      // Movement
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        velocity.x = -maxSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = maxSpeed;
      }
      
      // Shoot
      if (event.logicalKey == LogicalKeyboardKey.space) {
        shoot();
      }

    }

    if (event is KeyUpEvent) {
      // Movement
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = 0;
      }
    }
    
    return true; // Allow arrow events to other components
  }


  shoot() {
    final Bullet shot = Bullet(
        shooter: this,
        direction: Vector2(0, -1)
      )
      ..position = Vector2(position.x, position.y - height / 2);

    gameRef.add(shot);
    shotSfxPool.start();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet && other.shooter is! Player) {
      // Game lost
        gameRef.add(Explosion(position: absoluteCenter));
        removeFromParent();
        FlameAudio.play('game_over.mp3');
       gameRef.resetGame();
    }
  }

}