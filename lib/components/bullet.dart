import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
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
          anchor: Anchor.center,
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
  
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate( 
      
        count: 8,
        lifespan: 0.05,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: .75,
            paint: Paint()..color = Colors.orange,
          ),
        )
      
      ),
      
    );

    gameRef.add(particleComponent);
  }

  Vector2 getRandomVector() {
    Random random = Random();
    return (Vector2.random(random) - Vector2(0.5, direction.y)) * 250;
  }

}


