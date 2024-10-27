import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/components/space_invaders.dart';
import 'package:space_invaders/bloc/player/player_bloc.dart';
import 'package:space_invaders/bloc/player/player_event.dart';

class Player extends SpriteComponent with HasGameRef<SpaceInvaders>, KeyboardHandler, CollisionCallbacks {
  late PlayerBloc playerBloc;
  static late double maxMoveLeft;
  static late double maxMoveRight;
  
  static const double maxSpeed = 200.0;

  Player(this.playerBloc) : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    
    maxMoveLeft = size.x / 2;
    maxMoveRight = gameRef.size.x - size.x / 2;

    add(CircleHitbox(radius: width / 2));
    playerBloc.add(InitializePlayerEvent(gameRef, this)); // Initializes with game reference
  }

  @override
  void update(double dt) {
    super.update(dt);
    playerBloc.state.update(this, dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        playerBloc.add(StartMovingEvent(left: true));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        playerBloc.add(StartMovingEvent(left: false));
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        playerBloc.add(ShootEvent());
      } else if (event.logicalKey == LogicalKeyboardKey.keyG) {
        playerBloc.add(ChangeColorEvent());
      }
    } else if (event is KeyUpEvent &&
        (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      playerBloc.add(StopMovingEvent());
    }
    return true;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    playerBloc.add(HandleCollisionEvent(other));
  }

}
