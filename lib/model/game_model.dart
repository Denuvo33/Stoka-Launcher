import 'package:hive/hive.dart';

part 'game_model.g.dart';

@HiveType(typeId: 0)
class GameModel extends HiveObject {
  @HiveField(0)
  String? path;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? iconPath;

  @HiveField(3)
  String? type;

  GameModel({
    required this.path,
    required this.name,
    this.iconPath,
    this.type = 'games',
  });
}
