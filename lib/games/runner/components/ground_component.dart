import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../runner_game.dart';

class GroundComponent extends PositionComponent with HasGameRef<RunnerGame> {

  @override
  Future<void> onLoad() async {
    position = Vector2(0, gameRef.groundY);
    size     = Vector2(gameRef.size.x, RunnerGame.groundHeight);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF4CAF50),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, 6),
      Paint()..color = const Color(0xFF388E3C),
    );
  }
}
