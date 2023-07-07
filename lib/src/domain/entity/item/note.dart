import 'package:notes/src/domain/entity/item/item.dart';

class Note implements Item {
  Note({
    required this.id,
    required this.text,
    required this.title,
    required this.dateOfLastChange,
    this.controllerMap,
  });

  @override
  final int id;

  @override
  DateTime dateOfLastChange;

  @override
  String title;
  String text;
  Map<String, dynamic>? controllerMap;

  Note copyWith({
    String? title,
    String? text,
    DateTime? dateOfLastChange,
    Map<String, dynamic>? controllerMap,
  }) {
    return Note(
      id: id,
      text: text ?? this.text,
      title: title ?? this.title,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
      controllerMap: controllerMap ?? this.controllerMap,
    );
  }
}
