import 'package:flutter/material.dart';

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

  Folder copyWith({
    String? name,
    Color? background,
    Icon? icon,
    DateTime? dateOfLastChange,
  }) {
    return Folder(
      id: id,
      name: name ?? this.name,
      background: background ?? this.background,
      icon: icon ?? this.icon,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
    );
  }
}
