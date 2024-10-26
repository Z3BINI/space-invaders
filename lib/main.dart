import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/swarm.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Player player; //  Disallow null & reference alteration
  late final ParallaxComponent _parallaxBackground;
  late Swarm swarm; 
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();


    _parallaxBackground = await _loadParallax();
    startGame();

  }

  void startGame() {
    player = Player();
    swarm = Swarm();
    
    add(_parallaxBackground);
    add(player);
    add(swarm);
  }

  void resetGame() {
    Future.delayed(const Duration(seconds: 1), () {
      for (var child in children) {
        if (child is Player || child is ParallaxComponent) continue;

        child.removeFromParent();

      }

      add(Swarm());
      add(player);

    });
  }

  Future<ParallaxComponent> _loadParallax() async {
    final bgLayer = await loadParallaxLayer(
      ParallaxImageData('parallax/blue-back.png'),
      filterQuality: FilterQuality.none,
      velocityMultiplier: Vector2.zero(),
    );

    final bigPlanetLayer = await loadParallaxLayer(
      ParallaxImageData('parallax/planets.png'),
      filterQuality: FilterQuality.none,
      repeat: ImageRepeat.repeatY,
      velocityMultiplier: Vector2(0, 2),
    );

    final starsLayer = await loadParallaxLayer(
      ParallaxImageData('parallax/blue-stars.png'),
      filterQuality: FilterQuality.none,
      repeat: ImageRepeat.repeat,
      velocityMultiplier: Vector2(0, 20),
    );


    final parallax = Parallax(
      [
        bgLayer,
        bigPlanetLayer,
        starsLayer,
      ],
        baseVelocity: Vector2(0, -1),
      );

    return ParallaxComponent(parallax: parallax);
  }
  
}



void main() {
  runApp(GameWidget(game: SpaceInvaders()));
}