import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/components/player.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents {
  late final Player player; //  Disallow null & reference alteration

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    player = Player();

    add(player);
  }

}



void main() {
  runApp(GameWidget(game: SpaceInvaders()));
}