import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../runner_game.dart';

class ObstacleComponent extends SpriteComponent
    with HasGameRef<RunnerGame>, CollisionCallbacks {

  final double offsetX;
  bool _scored = false;

  ObstacleComponent({this.offsetX = 0});

  @override
  Future<void> onLoad() async {
    sprite   = await gameRef.loadSprite('banana_obstacle.png');
    size     = Vector2(45, 60);
    position = Vector2(
      gameRef.size.x + 60 + offsetX,
      gameRef.groundY - size.y + 10,
    );

    add(RectangleHitbox(
      size:     Vector2(size.x * 0.7, size.y * 0.8),
      position: Vector2(size.x * 0.15, size.y * 0.1),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.gameSpeed * dt;

    if (!_scored && position.x < gameRef.size.x * 0.15 - size.x) {
      _scored = true;
      gameRef.addScore();
    }

    if (position.x < -size.x - 20) removeFromParent();
  }
}
