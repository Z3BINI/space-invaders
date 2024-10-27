import 'package:flame/components.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/space_invaders.dart';

abstract class PlayerEvent {}

// Event to initialize the player with a reference to the game and player object
class InitializePlayerEvent extends PlayerEvent {
  final SpaceInvaders gameRef;
  final Player player;

  InitializePlayerEvent(this.gameRef, this.player);
}

// Event to start moving the player left or right
class StartMovingEvent extends PlayerEvent {
  final bool left;
  StartMovingEvent({required this.left});
}

// Event to stop the player's movement
class StopMovingEvent extends PlayerEvent {}

// Event to trigger the shooting action
class ShootEvent extends PlayerEvent {}

// Event to handle position updates in the game loop
class UpdatePositionEvent extends PlayerEvent {
  final double dt;

  UpdatePositionEvent(this.dt);
}

class PlayerDieEvent extends PlayerEvent {}

class PlayerRespawnEvent extends PlayerEvent {}

// Event to handle collision with another component (like an enemy or bullet)
class HandleCollisionEvent extends PlayerEvent {
  final PositionComponent other;

  HandleCollisionEvent(this.other);
}

// Event to randomly change the player color
class ChangeColorEvent extends PlayerEvent {}
