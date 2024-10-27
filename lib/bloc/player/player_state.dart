//Overwrites player's update when necessary and isolates behaviours by a state
import 'dart:ui';
import 'package:space_invaders/bloc/player/player_event.dart';
import 'package:space_invaders/components/explosion.dart';
import 'package:space_invaders/components/player.dart';

abstract class PlayerState {
  void onEnter(Player player) {}
  void update(Player player, double dt) {}
  void onExit(Player player) {}
}

// Player is idle (not moving or shooting)
class PlayerIdleState extends PlayerState {
  @override
  void onEnter(Player player) {
  }
}

// Player is moving (left or right)
class PlayerMovingState extends PlayerState {
  late bool isMovingLeft; 

  PlayerMovingState(bool movingLeft) {
    isMovingLeft = movingLeft;
  }
  
  @override
  void update(Player player, double dt) {
    player.position.x = clampDouble(player.position.x, Player.maxMoveLeft, Player.maxMoveRight);
    player.position.x += (isMovingLeft) ? -Player.maxSpeed * dt : Player.maxSpeed * dt;
  }
}

// Player has shot a bullet
class PlayerShootingState extends PlayerState {}

// Player is dead
class PlayerDeadState extends PlayerState {
  @override
  void onEnter(Player player) async {
    player.removeFromParent();
    
    player.gameRef.explosionSfxPool.start();
    player.gameRef.add(Explosion(position: player.absoluteCenter));
    
    player.gameRef.lives -= 1;
    player.gameRef.updateLifeUi();

    await Future.delayed(const Duration(seconds: 2));


    if (player.gameRef.lives <= 0) {
      player.gameRef.gameOver();
    } else {
      player.playerBloc.add(PlayerRespawnEvent());
    }
  }
}

// Player is respawning
class PlayerRespawningState extends PlayerState {}

// Player color has changed
class PlayerColorChangedState extends PlayerState {
  final Color color;
  PlayerColorChangedState(this.color);
}
