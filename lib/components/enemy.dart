import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_invaders/main.dart';
import 'package:space_invaders/components/Bullet.dart';

class Enemy extends SpriteComponent with HasGameRef<SpaceInvaders>, CollisionCallbacks{

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('enemy_1.png');

    add(
      CircleHitbox(
        radius: width / 2,
      ),
    );
  
    position = Vector2(100, 0);
  
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, 10) * dt; // Temporary behaviour
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
    }
  }

}