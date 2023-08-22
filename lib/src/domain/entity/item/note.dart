import 'package:notes/src/domain/entity/item/item.dart';

class Note extends Item {
  Note({
    required int id,
    required this.text,
    required String title,
    required DateTime dateOfLastChange,
    this.controllerMap,
  }) : super(id, title, dateOfLastChange);

  String text;

  Map<String, dynamic>? controllerMap;

  Note copyWith({
    int? id,
    String? title,
    String? text,
    DateTime? dateOfLastChange,
    Map<String, dynamic>? controllerMap,
  }) {
    return Note(
      id: id ?? this.id,
      text: text ?? this.text,
      title: title ?? this.title,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
      controllerMap: controllerMap ?? this.controllerMap,
    );
  }
}
