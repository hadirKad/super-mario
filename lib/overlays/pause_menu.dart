import 'package:flutter/material.dart';
import 'package:super_mario/game/super_mario_game.dart';
import 'package:super_mario/main.dart';

class PauseMenu extends StatelessWidget {
  static const id = "PauseMenu";
  final SuperMarioGame gameRef;
  const PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(100),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    ///first we remove the menu ui
                    gameRef.overlays.remove(id);

                    ///then we resume the engine
                    gameRef.resumeEngine();
                  },
                  child: const Text("Resume"))),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    ///first we remove the menu ui
                    //gameRef.overlays.remove(id);
                    ///then we resume the engine
                    gameRef.resumeEngine();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );

                    ///show the main menu ui
                    //gameRef.overlays.add(MainMenu.id);
                  },
                  child: const Text("exit")))
        ],
      )),
    );
  }
}
