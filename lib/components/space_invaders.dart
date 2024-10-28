import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/bloc/player/player_bloc.dart';
import 'package:space_invaders/components/player.dart';
import 'package:space_invaders/components/swarm.dart';
import 'package:flame_audio/flame_audio.dart';


class SpaceInvaders extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  static final Vector2 gameResolution = Vector2(500, 650); // Desired game resolution
  
  static const int maxLives = 3;
  int lives = maxLives;
  int points = 0;

  late final ParallaxComponent _parallaxBackground;
  late Player player;
  late Swarm swarm; 

  late TextComponent livesUi;
  late TextComponent pointsUi;

  final regular = TextPaint(
    style: TextStyle(
      fontSize: 16.0,
      color: BasicPalette.white.color,
    ),
  );

  
  late final AudioPool shotSfxPool; 
  late final AudioPool explosionSfxPool;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(resolution: gameResolution); // Set game resolution

    _parallaxBackground = await _loadParallax();
    add(_parallaxBackground);

    await FlameAudio.audioCache.loadAll(['explosion.mp3', 'background_music.mp3', 'shot.mp3', 'bounce.mp3', 'enemy_shot.mp3', 'stage_clear.mp3', 'game_over.mp3']);

    shotSfxPool = await FlameAudio.createPool('shot.mp3', maxPlayers: 1);
    explosionSfxPool = await FlameAudio.createPool('explosion.mp3', maxPlayers: 1);
  }

  void startGame() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('background_music.mp3', volume: .3);

    instantiatePlayer(true);
    instantiateUiElements();
    instantiateSwarm();
  }

  void resetGame() {
    instantiatePlayer(true);
    
    updateLifeUi();
    updatePointsUi();
    
    Future.delayed(const Duration(seconds: 1), () {
      instantiateSwarm();
    });
  }

  void stageCleared() {
    swarm.die();
    FlameAudio.play('stage_clear.mp3');
    Future.delayed(const Duration(seconds: 1), () {
      instantiateSwarm();
    });
  }

  void gameOver() {
    FlameAudio.play('game_over.mp3');
    swarm.die();// keep them from moving out of screen
    Future.delayed(const Duration(seconds: 2), () {
      resetGame();
    });
  }

  void instantiateUiElements() {
    livesUi = TextBoxComponent(
      textRenderer: regular,
      text: 'Lives: $lives',
      position: Vector2(0, 0),
    );

    pointsUi = TextBoxComponent(
      textRenderer: regular,
      text: 'Points: $points',
      position: Vector2(0, 30),
    );

    add(livesUi);
    add(pointsUi);
  }

  void instantiateSwarm() {
    swarm = Swarm();
    add(swarm);
  }

  void instantiatePlayer(bool isNewGame) {
    if (isNewGame) {
  
      lives = maxLives;
      points = 0;

      player = Player(PlayerBloc());
      add(player);
  
    } 
    
  }

  void instantiateAudioPlayers() {
    
  }

  void updatePointsUi() => pointsUi.text = 'Points: $points';
  void updateLifeUi() => livesUi.text = 'Lives: $lives';

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
