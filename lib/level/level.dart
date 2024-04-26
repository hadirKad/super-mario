import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_mario/actors/mario.dart';
import 'package:super_mario/constants/globals.dart';
import 'package:super_mario/game/super_mario_game.dart';
import 'package:super_mario/level/level_option.dart';
import 'package:super_mario/objects/platform.dart';

class Level extends World with HasGameRef<SuperMarioGame> {
  final LevelOption option;
  late Rectangle _levelBounds;
  late Mario _mario;

  Level(this.option) : super();

  @override
  Future<void> onLoad() async {
    TiledComponent level =
        await TiledComponent.load('Level01.tmx', Vector2.all(Globals.tileSize));

    gameRef.world.add(level);

    _levelBounds = Rectangle.fromPoints(
        Vector2(0, 0),
        Vector2(level.tileMap.map.width.toDouble(),
                level.tileMap.map.height.toDouble()) *
            Globals.tileSize);

    createPlatforms(level.tileMap);
    createActors(level.tileMap);
    _setUpCamera();

    return super.onLoad();
  }

  void createActors(RenderableTiledMap tileMap) {
    ObjectGroup? actorsLayer = tileMap.getLayer('Actors');
    if (actorsLayer == null) {
      throw Exception('actors layer not found');
    }
    for (final TiledObject obj in actorsLayer.objects) {

      switch (obj.name) {
        case 'Mario':
          _mario = Mario(position: Vector2(obj.x, obj.y), levelBounds: _levelBounds);
           gameRef.world.add(_mario);  
          break;
        default:
          break;
      }  
    }
  }

  void createPlatforms(RenderableTiledMap tileMap) {
    ObjectGroup? platformsLayer = tileMap.getLayer('Platforms');
    if (platformsLayer == null) {
      throw Exception('Platforms layer not found');
    }

    for (final TiledObject obj in platformsLayer.objects) {
      Platform platform = Platform(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height));
      gameRef.world.add(platform);    
    }
  }
  
  void _setUpCamera() {
    gameRef.cam.follow(_mario , maxSpeed: 1000);
    gameRef.cam.setBounds(Rectangle.fromPoints(_levelBounds.topRight, _levelBounds.topLeft));
  }
}
