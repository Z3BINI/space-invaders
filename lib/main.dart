import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/swarm.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Player player; //  Disallow null & reference alteration
  late Swarm swarm; 
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    startGame();

  }

  void startGame() {
    player = Player();
    swarm = Swarm();
    
    add(player);
    add(swarm);
  }

  void resetGame() {
    Future.delayed(const Duration(seconds: 1), () {
      for (var child in children) {
        if (child is Player) continue;

        child.removeFromParent();

      }

      add(Swarm());
      add(player);

    });
  }
}



void main() {
  runApp(GameWidget(game: SpaceInvaders()));
}