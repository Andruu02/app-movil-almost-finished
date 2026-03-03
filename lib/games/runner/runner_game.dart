import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'components/player_component.dart';
import 'components/obstacle_component.dart';
import 'components/ground_component.dart';
import 'components/background_component.dart';
import '../../services/partida_service.dart';

class RunnerGame extends FlameGame with TapCallbacks, HasCollisionDetection {

  final int idPersonaje;
  final String spriteRunner1;
  final String spriteRunner2;

  RunnerGame({
    this.idPersonaje   = 1,
    this.spriteRunner1 = 'player_1.png',
    this.spriteRunner2 = 'player_2.png',
  });

  late PlayerComponent player;

  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  int get score => scoreNotifier.value;

  double gameSpeed = 220;
  static const double maxGameSpeed      = 500;
  static const double speedIncreaseRate = 8;

  double _spawnTimer    = 0;
  double _spawnInterval = 1.8;
  final Random _random  = Random();
  bool _isGameOver      = false;

  static const double groundHeight = 80;
  double get groundY => size.y - groundHeight;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await images.loadAll([spriteRunner1, spriteRunner2, 'banana_obstacle.png']);

    add(BackgroundComponent());
    add(GroundComponent());
    player = PlayerComponent(
      sprite1Name: spriteRunner1,
      sprite2Name: spriteRunner2,
    );
    add(player);
  }

  @override
  void update(double dt) {
    if (_isGameOver) return;
    super.update(dt);

    if (gameSpeed < maxGameSpeed) gameSpeed += speedIncreaseRate * dt;

    _spawnInterval = (_spawnInterval - dt * 0.01).clamp(0.8, 1.8);

    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnObstacle();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_isGameOver) player.jump();
  }

  void _spawnObstacle() {
    final count = _random.nextBool() ? 1 : 2;
    for (int i = 0; i < count; i++) {
      add(ObstacleComponent(offsetX: i * 55.0));
    }
  }

  void addScore() => scoreNotifier.value++;

  void triggerGameOver() {
    if (_isGameOver) return;
    _isGameOver = true;

    PartidaService.guardarPartida(
      juego:       'runner',
      puntaje:     score,
      idPersonaje: idPersonaje,
    );

    pauseEngine();
    overlays.remove('score');
    overlays.remove('backButton');
    overlays.add('gameOver');
  }

  void resetGame() {
    _isGameOver = false;
    scoreNotifier.value = 0;
    gameSpeed      = 220;
    _spawnTimer    = 0;
    _spawnInterval = 1.8;
    children.whereType<ObstacleComponent>().toList().forEach(remove);
    player.reset();
    overlays.remove('gameOver');
    overlays.add('score');
    overlays.add('backButton');
    resumeEngine();
  }
}
