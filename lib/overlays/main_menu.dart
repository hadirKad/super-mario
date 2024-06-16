import 'package:flutter/material.dart';
import 'package:super_mario/game/game_play.dart';
import 'package:super_mario/game/super_mario_game.dart';

class MainMenu extends StatelessWidget {
  static const id = "MainMenu";
  final SuperMarioGame gameRef;
  const MainMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pexels-maobphoto-17122728.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      ///first we remove the menu ui
                      gameRef.overlays.remove(id);
        
                      ///then we add our game
                      gameRef.add(GamePlay());
                    },
                    child: const Text("play" ,style: TextStyle(fontWeight: FontWeight.bold),))),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("setting" ,style: TextStyle(fontWeight: FontWeight.bold))))
          ],
        )),
      ),
    );
  }
}
