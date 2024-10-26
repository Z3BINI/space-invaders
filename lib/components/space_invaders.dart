import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/swarm.dart';
import 'package:flame_audio/flame_audio.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  static final Vector2 gameResolution = Vector2(500, 650); // Desired game resolution
  late final ParallaxComponent _parallaxBackground;
  late Player player;
  late Swarm swarm; 

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(resolution: gameResolution); // Set game resolution

    _parallaxBackground = await _loadParallax();
    add(_parallaxBackground);
  }

  void startGame() async {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('background_music.mp3', volume: .3);

    instantiateGameComponents();
  }

  void resetGame() {
    Future.delayed(const Duration(seconds: 2), () {
      for (var child in children) {
        if (child is ParallaxComponent) continue; // Keep parallax while resetting
        child.removeFromParent();
      }
      instantiateGameComponents();
    });
  }

  void instantiateGameComponents() {
    player = Player();
    swarm = Swarm(); 

    add(player);
    add(swarm);
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
