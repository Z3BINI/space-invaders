import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_invaders/components/space_invaders.dart';

class Bullet extends SpriteComponent with HasGameRef<SpaceInvaders> {

  static const double shotSpeed = 750;
  late final Vector2 direction;
  late final SpriteComponent shooter;

  Bullet({
    required this.direction,
    required this.shooter,
    super.position,
  }) : super(
          size: Vector2(8, 16),
          anchor: (direction == Vector2(0, -1) ? Anchor.bottomCenter : Anchor.topCenter), // To avoid self hits
  );
  
  @override
  FutureOr<void> onLoad() async {

    sprite = await game.loadSprite('bullet.png');
  
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }


  @override
  void update(double dt) {
    position += direction * shotSpeed * dt;
    
    if (position.y <= -size.y || position.y >= gameRef.size.y + size.y / 2) { // Vertical out of screen check
      removeFromParent();
    }
  
  }
}