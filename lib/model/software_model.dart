import 'package:hive/hive.dart';

part 'software_model.g.dart';

@HiveType(typeId: 1)
class SoftwareModel extends HiveObject {
  @HiveField(0)
  String? path;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? iconPath;

  SoftwareModel({this.path, this.name, this.iconPath});
}
