import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/components/enemy.dart';
import 'package:space_invaders/components/player.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Player player; //  Disallow null & reference alteration

  double spawnTimer = 0;
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    player = Player();

    add(player);

    add(Enemy());
  }

  @override
  void update(double dt) {
    super.update(dt);

    spawnTimer += dt;

    if (spawnTimer >= 5) {
      spawnTimer = 0;
      add(Enemy());
    }
  }

}



void main() {
  runApp(GameWidget(game: SpaceInvaders()));
}