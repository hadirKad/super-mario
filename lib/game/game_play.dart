import 'dart:async';

import 'package:flame/components.dart';
import 'package:super_mario/game/super_mario_game.dart';
import 'package:super_mario/level/level.dart';
import 'package:super_mario/level/level_option.dart';

class GamePlay extends Component with HasGameRef<SuperMarioGame>{
  
   Level? _currentlevel; 
   
  @override
  FutureOr<void> onLoad() {
    loadLevel(LevelOption.lv_1);
    return super.onLoad();
  }

  void loadLevel(LevelOption option) {
     _currentlevel?.removeFromParent();
     _currentlevel = Level(option);
     add(_currentlevel!);
  }
}