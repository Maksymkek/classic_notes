import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/item/item.dart';

class Folder implements Item {
  Folder({
    required this.id,
    required this.title,
    required this.background,
    required this.icon,
    required this.dateOfLastChange,
  });

  @override
  final int id;

  @override
  DateTime dateOfLastChange;

  @override
  String title;

  Color background;
  Icon icon;

  Folder copyWith({
    String? title,
    Color? background,
    Icon? icon,
    DateTime? dateOfLastChange,
  }) {
    return Folder(
      id: id,
      title: title ?? this.title,
      background: background ?? this.background,
      icon: icon ?? this.icon,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
    );
  }
}
