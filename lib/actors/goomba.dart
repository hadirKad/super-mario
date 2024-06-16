import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:super_mario/actors/mario.dart';
import 'package:super_mario/constants/globals.dart';
import 'package:super_mario/game/super_mario_game.dart';

class Goomba extends SpriteAnimationComponent
    with HasGameRef<SuperMarioGame>, CollisionCallbacks {
  final double _speed = 50;

  Goomba({required Vector2 position})
      : super(
            position: position,
            size: Vector2(20, 11),
            anchor: Anchor.topCenter) {
    Vector2 targetPosition = position;
    targetPosition.x = targetPosition.x - 100;
    final SequenceEffect effect = SequenceEffect(
      [
        MoveToEffect(
          targetPosition,
          EffectController(speed: _speed),
          onComplete: () => flipHorizontallyAroundCenter(),
        ),
        MoveToEffect(
          position,
          EffectController(speed: _speed),
          onComplete: () => flipHorizontallyAroundCenter(),
        ),
      ],
      infinite: true,
      alternate: true,
    );

    add(effect);
    add(RectangleHitbox());
    //debugMode = true;
  }

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        gameRef.images.fromCache("Enemies/Turtle/Idle 1 (44x26).png"),
        SpriteAnimationData.sequenced(
            amount: 14,
            stepTime: Globals.marioSpriteStepTime,
            textureSize: Vector2(44, 26)));

    return super.onLoad();
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Mario) {
      if (!other.isOnGround) {
        other.jump();
        add(OpacityEffect.fadeOut(
            EffectController(alternate: true, duration: 0.2, repeatCount: 1 , ),
            onComplete: ()=> removeFromParent()));
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
