import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/item/item.dart';

class Folder extends Item {
  Folder({
    required int id,
    required String title,
    required this.background,
    required this.icon,
    required DateTime dateOfLastChange,
  }) : super(id, title, dateOfLastChange);

  Color background;
  Icon icon;

  Folder copyWith({
    int? id,
    String? title,
    Color? background,
    Icon? icon,
    DateTime? dateOfLastChange,
  }) {
    return Folder(
      id: id ?? this.id,
      title: title ?? this.title,
      background: background ?? this.background,
      icon: icon ?? this.icon,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
    );
  }
}
