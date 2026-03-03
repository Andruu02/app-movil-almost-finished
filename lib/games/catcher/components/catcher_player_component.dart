import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../catcher_game.dart';
import 'falling_object_component.dart';

class CatcherPlayerComponent extends SpriteComponent
    with HasGameRef<CatcherGame>, CollisionCallbacks {

  static const double playerWidth  = 90.0;
  static const double playerHeight = 120.0;
  static const double lerpSpeed    = 18.0;

  final String spriteName;
  double _targetX = 0;

  CatcherPlayerComponent({required this.spriteName});

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(spriteName);
    size   = Vector2(playerWidth, playerHeight);

    _targetX = gameRef.size.x / 2 - playerWidth / 2;
    position = Vector2(_targetX, gameRef.groundY - playerHeight);

    add(RectangleHitbox(
      size:     Vector2(playerWidth * 0.85, playerHeight * 0.30),
      position: Vector2(playerWidth * 0.075, 0),
    ));
  }

  void moveTo(double touchX) {
    _targetX = (touchX - playerWidth / 2)
        .clamp(0.0, gameRef.size.x - playerWidth);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += (_targetX - position.x) * lerpSpeed * dt;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is FallingObjectComponent && !other.caught) {
      other.caught = true;
      gameRef.objectCaught(other.type);
      other.removeFromParent();
    }
  }

  void reset() {
    _targetX = gameRef.size.x / 2 - playerWidth / 2;
    position = Vector2(_targetX, gameRef.groundY - playerHeight);
  }
}
