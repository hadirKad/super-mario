import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:super_mario/constants/globals.dart';
import 'package:super_mario/game/super_mario_game.dart';
import 'package:super_mario/objects/platform.dart';
import 'package:super_mario/overlays/pause_menu.dart';

enum MarioAnimationState {
  idle,
  walking,
  jumping,
}

class Mario extends SpriteAnimationGroupComponent<MarioAnimationState>
    with HasGameRef<SuperMarioGame>, CollisionCallbacks, KeyboardHandler {
  final double _gravity = 15;
  Vector2 velocity = Vector2.zero();

  //to determine if super mario in on the ground or not
  final Vector2 _up = Vector2(0, -1);
  bool _jumpInput = false;
  //because he start by jumping
  bool isOnGround = false;

  bool _paused = false;

  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  double _jumpSpeed = 300;

  static const double _minMoveSpeed = 125;
  static const double _maxMoveSpeed = -_minMoveSpeed + 100;
  double _currentSpeed = _minMoveSpeed;
  bool isFacingRight = true;
  int _hAxisInput = 0;

  Mario({required Vector2 position, required Rectangle levelBounds})
      : super(
            position: position, size: Vector2(16, 16), anchor: Anchor.center) {
    //debugMode = true;
    _minClamp = levelBounds.topLeft + (size / 2);
    _maxClamp = levelBounds.bottomRight + (size / 2);

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dt > 0.05) return;
    velocityUpdate();
    positionUpdate(dt);
    speedUpdate();
    facingDirectionUpdate();
    animationUpdate();
    jumpUpdate();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.arrowUp) ? true : false;

    if(keysPressed.contains(LogicalKeyboardKey.keyA)){
      _pause();
    }

    return super.onKeyEvent(event, keysPressed);
  }

   void  _pause(){
     FlameAudio.play(Globals.pauseSFX);

     //_paused ? gameRef.resumeEngine() : gameRef.pauseEngine();

     //_paused = !_paused ;
     gameRef.pauseEngine();
     gameRef.overlays.add(PauseMenu.id);

   }

  void jumpUpdate() {
    if (_jumpInput && isOnGround) {
      jump();
    }
  }

  void jump() {
    velocity.y -= _jumpSpeed;
    isOnGround = false;
    FlameAudio.play(Globals.jumpSmallSFX);
  }

  void speedUpdate() {
    if (_hAxisInput == 0) {
      _currentSpeed = _minMoveSpeed;
    } else {
      if (_currentSpeed <= _maxMoveSpeed) {
        _currentSpeed++;
      }
    }
  }

  void facingDirectionUpdate() {
    if (_hAxisInput > 0) {
      isFacingRight = true;
    } else {
      isFacingRight = false;
    }
    if ((_hAxisInput < 0 && scale.x > 0) || (_hAxisInput > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void animationUpdate() {
    if (!isOnGround) {
      current = MarioAnimationState.jumping;
    } else {
      if (_hAxisInput == 0) {
        current = MarioAnimationState.idle;
      } else {
        current = MarioAnimationState.walking;
      }
    }
  }

  void velocityUpdate() {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpSpeed, 150);

    velocity.x = _hAxisInput * _currentSpeed;
  }

  void positionUpdate(double dt) {
    Vector2 distance = velocity * dt;
    position += distance;
    position.clamp(_minClamp, _maxClamp);
  }

  @override
  Future<void> onLoad() async {
    final SpriteAnimation idleAnimation = _spriteAnimation(11, "Idle");
    final SpriteAnimation walkingAnimation = _spriteAnimation(12, "Run");
    final SpriteAnimation jumpingAnimation = _spriteAnimation(1, "Jump");

    ///list of all animations
    animations = {
      MarioAnimationState.idle: idleAnimation,
      MarioAnimationState.walking: walkingAnimation,
      MarioAnimationState.jumping: jumpingAnimation,
    };

    ///set the current animation
    current = MarioAnimationState.idle;
    return super.onLoad();
  }

  ///function to create sprite animation
  SpriteAnimation _spriteAnimation(int amount, String state) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache("Main Characters/Ninja Frog/$state (32x32).png"),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: Globals.marioSpriteStepTime,
            textureSize: Vector2.all(32)));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        platformPositionCheck(intersectionPoints);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void platformPositionCheck(Set<Vector2> intersectionPoints) {
    final Vector2 mid =
        (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;
    final Vector2 collisionNormal = absoluteCenter - mid;
    double penetrationLenght = (size.x / 2) - collisionNormal.length;
    collisionNormal.normalize();
    if (_up.dot(collisionNormal) > 0.9) {
      isOnGround = true;
    }
    position += collisionNormal.scaled(penetrationLenght);
  }
}
