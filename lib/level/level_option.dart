import 'package:super_mario/constants/globals.dart';

enum LevelOption{
   
  lv_1(Globals.lv_1_1 , '1-1');
  
  const LevelOption(this.pathName , this.name);

  final String pathName;
  final String name;
}