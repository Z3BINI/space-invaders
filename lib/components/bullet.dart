import 'dart:async';
import 'package:flame/components.dart';
import 'package:space_invaders/main.dart';

class Bullet extends SpriteComponent with HasGameRef<SpaceInvaders> {

  static const double shotSpeed = 750;
  late final Vector2 direction;

  Bullet({
    required this.direction,
    super.position,
  }) : super(
          size: Vector2(4, 8),
          anchor: Anchor.center,
  );
  
  @override
  FutureOr<void> onLoad() async {

    sprite = await game.loadSprite('bullet.png');
  
  }


  @override
  void update(double dt) {
    position += direction * shotSpeed * dt;
    
    if (position.y <= -size.y || position.y >= gameRef.size.y + size.y / 2) { // Vertical out of screen check
      removeFromParent();
    }
  
  }
}