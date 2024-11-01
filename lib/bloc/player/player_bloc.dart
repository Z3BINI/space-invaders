// Will take care of transitioning from current state to new state and receive the events
import 'package:flame/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_invaders/components/bullet.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/space_invaders.dart';
import 'player_event.dart';
import 'player_state.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  late SpaceInvaders gameRef;
  late Player player;
  
  bool _canShoot = true;

  PlayerBloc() : super(PlayerIdleState()) {

    on<InitializePlayerEvent>((event, emit) {
      gameRef = event.gameRef;
      player = event.player;
      _applyRandomColor();
      _resetPosition();
      emit(PlayerIdleState());
    });

    on<StartMovingEvent>((event, emit) {
      state.onExit(player); // Exit current state gracefully

      final newState = PlayerMovingState(event.left);
      newState.onEnter(player);
      emit(newState);
    });

    on<StopMovingEvent>((event, emit) {
      state.onExit(player); // Exit current state gracefully
      
      final newState = PlayerIdleState();
      newState.onEnter(player);
      emit(newState);
    });
    
    on<ShootEvent>((event, emit) {
      if (_canShoot) { 
        _shoot();
        _shootCoolDown();
      }
    
    });

    on<HandleCollisionEvent>((event, emit) {
        
      if (event.other is Bullet) {
        
        final Bullet bullet = event.other as Bullet;
        
        if (bullet.shooter is! Player) {
          event.other.removeFromParent(); // Remove bullet
          add(PlayerDieEvent()); // trigger death
        }
      
      }      

    });

    on<PlayerRespawnEvent>((event, emit) {
      _resetPosition();
      state.onExit(player); // Exit current state gracefully
      final newState = PlayerRespawningState();
      newState.onEnter(player);
      emit(newState);   
    });

    on<PlayerDieEvent>((event, emit) {
      state.onExit(player); // Exit current state gracefully
      final newState = PlayerDeadState();
      newState.onEnter(player);
      emit(newState);   
    });
    

    on<ChangeColorEvent>((event, emit) => _applyRandomColor());
  }

  void _shoot() {
    gameRef.shotSfxPool.start();
    final Bullet bullet = Bullet(shooter: player, direction: Vector2(0, -1))
      ..position = Vector2(player.position.x, player.position.y - player.height / 2);
    gameRef.add(bullet);
  }

  void _applyRandomColor() {
    player.decorator.removeLast();
    Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final playerColorDecorator = PaintDecorator.tint(randomColor);
    player.decorator.addLast(playerColorDecorator);
  }

  void _shootCoolDown() async {
    _canShoot = false;
    await Future.delayed(const Duration(milliseconds: 250));
    _canShoot = true;
  }

  void _resetPosition() => player.position = Vector2(gameRef.size.x / 2, gameRef.size.y - player.size.y / 2);
}
