import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:notes/src/domain/entity/folder.dart';

part 'folder_data_model.g.dart';

@HiveType(typeId: 0)
class FolderDataModel extends HiveObject {
  FolderDataModel(
      {required this.id,
      required this.name,
      required this.background,
      required this.icon,
      required this.dateOfLastChange,
      required this.iconSize,
      required this.iconColor,
      required this.iconFamily});

  @HiveField(0)
  String name;

  @HiveField(1)
  final int id;

  @HiveField(2)
  int background;

  @HiveField(3)
  int icon;

  @HiveField(4)
  String dateOfLastChange;

  @HiveField(5)
  int iconColor;

  @HiveField(6)
  double iconSize;

  @HiveField(7)
  String? iconFamily;

  Folder toFolder() {
    final folder = Folder(
      id: id,
      name: name,
      background: Color(background),
      icon: Icon(
        IconData(icon, fontFamily: iconFamily),
        color: Color(iconColor),
        size: iconSize,
      ),
      dateOfLastChange: DateTime.parse(dateOfLastChange),
    );
    return folder;
  }

  static FolderDataModel fromFolder(Folder folder, int key) {
    return FolderDataModel(
      id: key,
      name: folder.name,
      background: folder.background.value,
      icon: folder.icon.icon!.codePoint,
      dateOfLastChange: folder.dateOfLastChange.toString(),
      iconSize: folder.icon.size!,
      iconColor: folder.icon.color!.value,
      iconFamily: folder.icon.icon!.fontFamily,
    );
  }
}
