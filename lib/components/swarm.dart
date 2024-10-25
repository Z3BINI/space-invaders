import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_invaders/components/enemy.dart';
import 'package:space_invaders/main.dart';
import 'package:space_invaders/components/Bullet.dart';


class Swarm extends PositionComponent with HasGameRef<SpaceInvaders>{
  // Swarm grid data
  static final Vector2 gridSize = Vector2(1, 5);
  static int rowSpacing = 22; 
  static int columnSpacing = 16; 
  // Swarm Movement data
  static const double xMoveAmount = 2.5;
  static const double yMoveAmount = 32;
  static double baseMoveTime = 0.5;
  static double hardestMoveTime = 0.001;
  static Timer moveTimer = Timer(baseMoveTime);
  static bool isMovingRight = true;
  static bool reachedEdge = false;
  // Swarm health data
  static double enemiesTotal = gridSize.x * gridSize.y;
  static late double enemiesAlive;
  // Shooting data
  static late List enemyShooters;
  static late Enemy currentShooter;
  static late SpawnComponent _bulletSpawner;
  // Time data
  static double shootCdmin = 0.5;
  static double shootCdmax = 2;
  static double shootDurTimeMin = 1.5;
  static double shootDurTimeMax = 4.5;
  static Timer shootCdTimer = Timer(shootCdmax);
  static Timer shootActiveTimer = Timer(shootDurTimeMin);
  
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // Game restart reset
    enemiesAlive = gridSize.x * gridSize.y;
    enemyShooters = <Enemy>[]; 
    isMovingRight = true;

    setSwarmGrid();
    pickShooter();
    
    _bulletSpawner = SpawnComponent(
    period: 1.5,
    selfPositioning: true,
    factory: (index) {
      return Bullet(
        direction: Vector2(0, 1),
        position: currentShooter.absolutePositionOfAnchor(Anchor.bottomCenter),
      );
    },
    autoStart: false,
    );
    gameRef.add(_bulletSpawner);
    
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Timers countdown
    moveTimer.update(dt); 
    shootCdTimer.update(dt);
    shootActiveTimer.update(dt);

    if (moveTimer.finished) { // Movement timer
      move();

      // Linear interpolation from baseMoveTime to hardestMoveTime in relation to enemies left
      double currentMoveTime = baseMoveTime + (hardestMoveTime - baseMoveTime) * (enemiesTotal - enemiesAlive)/(enemiesTotal - 1); 
      moveTimer = Timer(currentMoveTime);
      
      moveTimer.start(); 
    }

    if (shootCdTimer.finished) { // Between shot cooldown
      pickShooter();
      startShooting();

      shootActiveTimer = Timer(Random().nextDouble() * shootDurTimeMax + shootDurTimeMin);

      shootCdTimer.stop();
      shootActiveTimer.start();
    }

    if (shootActiveTimer.finished) { // Shooting cooldown
      stopShooting();

      shootCdTimer = Timer(Random().nextDouble() * shootCdmax + shootCdmin);

      shootActiveTimer.stop();
      shootCdTimer.start();
    }
  }

  void move() {
    if (reachedEdge) { 
      reachedEdge = false;
      position.y += yMoveAmount;
      isMovingRight = !isMovingRight;
      return; // Ignore lateral movement on the downward move frame
    }
    
    isMovingRight ? (position.x += xMoveAmount) : (position.x -= xMoveAmount);
  }


  void setSwarmGrid() {
    Vector2 posIncrement = Vector2.zero();
    
    List menAbove = <Enemy>[];

    for (int row = 1; row <= gridSize.y; row++) {

      List rowAccomulation = <Enemy>[];
      
      for (int column = 1; column <= gridSize.x; column++) {
        // Instantiate enemy and add to swarm
        Enemy enemy = Enemy();
        enemy.position = posIncrement;
        add(enemy);
        
        // Store reference to the enemy above and below
        if (menAbove.isNotEmpty) {
          enemy.manAbove = menAbove[column-1];
          menAbove[column-1].manBelow = enemy;
        }

        // To set the menAbove array for next row
        rowAccomulation.add(enemy);

        // Initiate the bottom row of grid as shooters
        if (row == gridSize.y) enemyShooters.add(enemy); 
        
        posIncrement.x += Enemy.enemySize.x + columnSpacing;
      }
      menAbove = [...rowAccomulation];

      posIncrement.x = 0;
      posIncrement.y += Enemy.enemySize.y + rowSpacing;
    }
  }

  void pickShooter() {
    enemyShooters.shuffle();
    currentShooter = enemyShooters[0];
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }
  
}