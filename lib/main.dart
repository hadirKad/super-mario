import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_mario/constants/globals.dart';
import 'package:super_mario/constants/sprite_sheets.dart';
import 'package:super_mario/game/super_mario_game.dart';
import 'package:super_mario/overlays/main_menu.dart';
import 'package:super_mario/overlays/pause_menu.dart';

void main() async {
  ///waiting for flutter to initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SpriteSheets.load();

  await FlameAudio.audioCache.loadAll(
    [
      Globals.jumpSmallSFX,
      Globals.pauseSFX,
      Globals.bumpSFX,
      Globals.powerUpAppearsSFX,
    ],
  );

  ///make the game full screen
  await Flame.device.fullScreen();

  ///make the phone horizontal
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

//we use this instance in the real mood
final _game = SuperMarioGame();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Super mario",
      home: Scaffold(
        body: GameWidget<SuperMarioGame>(
          game: kDebugMode ? SuperMarioGame() : _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(gameRef: game),
            PauseMenu.id: (context, game) => PauseMenu(gameRef: game),
          },
          initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}
