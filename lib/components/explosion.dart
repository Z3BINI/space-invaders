import 'dart:async';
import 'package:flame/components.dart';
import 'package:space_invaders/components/space_invaders.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef<SpaceInvaders> {

  Explosion({
    super.position,
  }) : super(
    size: Vector2.all(50),
    anchor: Anchor.center,
    removeOnFinish: true,  
  );

  @override
  FutureOr<void> onLoad() async {

    animation = await game.loadSpriteAnimation(
      'explosion.png', 
      SpriteAnimationData.sequenced(
        amount: 16, 
        stepTime: .025, 
        textureSize: Vector2(64, 59),
        loop: false,
      ),
    );
  }
}