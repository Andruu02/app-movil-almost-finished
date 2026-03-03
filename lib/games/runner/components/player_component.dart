import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../runner_game.dart';
import 'obstacle_component.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameRef<RunnerGame>, CollisionCallbacks {

  double _velocityY = 0;
  bool   _onGround  = true;

  static const double gravity      = 900;
  static const double jumpForce    = -480;
  static const double playerXRatio = 0.15;

  final String sprite1Name;
  final String sprite2Name;

  PlayerComponent({required this.sprite1Name, required this.sprite2Name});

  @override
  Future<void> onLoad() async {
    final sprite1 = await gameRef.loadSprite(sprite1Name);
    final sprite2 = await gameRef.loadSprite(sprite2Name);

    animation = SpriteAnimation.spriteList([sprite1, sprite2], stepTime: 0.15);

    size     = Vector2(80, 100);
    position = Vector2(
      gameRef.size.x * playerXRatio,
      gameRef.groundY - size.y,
    );

    add(RectangleHitbox(
      size:     Vector2(size.x * 0.7, size.y * 0.85),
      position: Vector2(size.x * 0.15, size.y * 0.1),
    ));
  }

  void jump() {
    if (_onGround) {
      _velocityY = jumpForce;
      _onGround  = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocityY += gravity * dt;
    position.y += _velocityY * dt;

    final groundLimit = gameRef.groundY - size.y;
    if (position.y >= groundLimit) {
      position.y = groundLimit;
      _velocityY = 0;
      _onGround  = true;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is ObstacleComponent) gameRef.triggerGameOver();
  }

  void reset() {
    _velocityY = 0;
    _onGround  = true;
    position   = Vector2(
      gameRef.size.x * playerXRatio,
      gameRef.groundY - size.y,
    );
  }
}
