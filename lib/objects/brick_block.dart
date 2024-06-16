import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:super_mario/constants/animation_configs.dart';
import 'package:super_mario/constants/globals.dart';
import 'package:super_mario/objects/game_block.dart';

class BrickBlock extends GameBlock {
  

  BrickBlock({required Vector2 position , required bool shouldCrumble}):super(animation:  AnimationConfigs.block.brickBlockIdle(),
  position: position,
  shouldCrumble: shouldCrumble);

  @override
  void hit(){
    if(shouldCrumble){
      FlameAudio.play(Globals.brickBlockSFX);
      animation = AnimationConfigs.block.brickBlockHit();
    }
    
    super.hit();
  }

}