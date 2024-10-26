import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_invaders/main.dart';
import 'package:space_invaders/components/bullet.dart';
import 'package:space_invaders/components/swarm.dart';

class Enemy extends SpriteComponent with HasGameRef<SpaceInvaders>, CollisionCallbacks {
  static final Vector2 enemySize = Vector2.all(32); // For swarm grid to have a size reference
  // To help keep track of possible shooters (downmost enemy)
  Enemy? manAbove;
  Enemy? manBelow;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    
    size = enemySize; // Safe keeping the size as expected by the grid
    sprite = await gameRef.loadSprite('enemy_1.png');

    add(
      CircleHitbox(
        radius: width / 2,
      ),
    );
  } 

  @override
  void update(double dt) {
    super.update(dt);
    
    // Because when enemies on the edge of swam die the boundries change
    if ((absolutePositionOfAnchor(Anchor.topRight).x > gameRef.size.x && Swarm.isMovingRight) || (absolutePositionOfAnchor(Anchor.topLeft).x < 0 && !Swarm.isMovingRight)) {
    
      Swarm.reachedEdge = true;
    } 
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);


    if (other is Bullet &&  other.shooter is! Enemy) {
      Swarm.enemiesAlive -= 1; // For the swarm to move faster with each casualty
      removeFromParent();
      other.removeFromParent();

      if (Swarm.enemiesAlive > 0) { 
        manAbove?.manBelow = manBelow?.manBelow;
        manBelow?.manAbove = manAbove?.manAbove;

        // If was shooter get enemy above into the shooter pool
        if (Swarm.enemyShooters.remove(this)) {        
          if (manAbove != null) Swarm.enemyShooters.add(manAbove);
          Swarm().pickShooter();
        }

      } else {
        // Game won
        gameRef.resetGame();
      }
    }
  }
}