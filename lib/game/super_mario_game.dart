import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:super_mario/level/level.dart';
import 'package:super_mario/level/level_option.dart';

class SuperMarioGame extends FlameGame with HasCollisionDetection , HasKeyboardHandlerComponents{
  @override
  Color backgroundColor() => const Color(0xFF789cff);

  @override
  final World world = World();
  late CameraComponent cam;
  Level? _currentlevel; 

  @override
  FutureOr<void> onLoad() async {
    await images.loadAll([
      "Main Characters/Ninja Frog/Idle (32x32).png",
      "Main Characters/Ninja Frog/Run (32x32).png",
      "Main Characters/Ninja Frog/Jump (32x32).png",
      "Main Characters/Ninja Frog/Fall (32x32).png",
      "Items/Fruits/Collected.png",
      "Items/Fruits/Pineapple.png",
      "Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
      "Items/Boxes/Box2/Idle.png",
      "HUD/left_button.png",
      "HUD/right_button.png",
      'HUD/Knob.png',
      'HUD/Joystick.png',
      'HUD/JumpButton.png'
    ]);
    cam = CameraComponent(world: world)
      ..viewport.size = Vector2(450, 50)
      //we do 500 to make sure the player is visibile
      ..viewport.position = Vector2(500, 0)
      //how close we want to be to the game
      ..viewfinder.visibleGameSize = Vector2(500, 50)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;
    addAll([world, cam]);
    loadLevel(LevelOption.lv_1);
    return super.onLoad();
  }
  
  void loadLevel(LevelOption option) {
     _currentlevel?.removeFromParent();
     _currentlevel = Level(option);
     add(_currentlevel!);
  }
}
