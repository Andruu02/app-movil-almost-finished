import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../catcher_game.dart';

const _goodObjects = ['icecream.png', 'banana.png'];
const _badObjects  = ['fish.png'];

class FallingObjectComponent extends SpriteComponent
    with HasGameRef<CatcherGame>, CollisionCallbacks {

  final ObjectType type;
  final double startX;
  bool caught = false;

  double _wobbleTime = 0;
  final double _wobbleAmplitude;
  final double _wobbleFrequency;

  static final Random _random = Random();

  FallingObjectComponent({required this.type, required this.startX})
      : _wobbleAmplitude = _random.nextDouble() * 14,
        _wobbleFrequency = 1.5 + _random.nextDouble() * 1.5;

  @override
  Future<void> onLoad() async {
    final spriteName = type == ObjectType.good
        ? _goodObjects[_random.nextInt(_goodObjects.length)]
        : _badObjects[_random.nextInt(_badObjects.length)];

    sprite   = await gameRef.loadSprite(spriteName);
    size     = type == ObjectType.good ? Vector2(52, 52) : Vector2(62, 52);
    position = Vector2(startX - size.x / 2, -size.y);

    add(RectangleHitbox(
      size:     Vector2(size.x * 0.75, size.y * 0.75),
      position: Vector2(size.x * 0.125, size.y * 0.125),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (caught) return;

    position.y += gameRef.objectFallSpeed * dt;
    _wobbleTime += dt;
    position.x = startX - size.x / 2
        + sin(_wobbleTime * _wobbleFrequency * pi) * _wobbleAmplitude;

    if (position.y > gameRef.size.y + size.y) {
      gameRef.objectMissed(type);
      removeFromParent();
    }
  }
}
