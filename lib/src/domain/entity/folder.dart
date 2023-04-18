import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/note.dart';

class Folder {
  Folder({
    required this.id,
    required this.name,
    required this.background,
    required this.icon,
    required this.dateOfLastChange,
  });

  String name;
  final int id;
  Color background;
  Icon icon;
  DateTime dateOfLastChange;
  List<Note>? notes;

  static Folder from(Folder folder) {
    var newFolder = Folder(
      id: folder.id,
      name: folder.name,
      background: folder.background,
      icon: folder.icon,
      dateOfLastChange: folder.dateOfLastChange,
    );
    return newFolder;
  }

/*  @override
  bool operator ==(Object other) {
    return id == (other as Folder).id;
  }*/
}
