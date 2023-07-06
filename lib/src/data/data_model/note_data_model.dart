import 'package:hive/hive.dart';
import 'package:notes/src/data/data_model/adapter_id/adapter_id.dart';
import 'package:notes/src/domain/entity/note.dart';

part 'note_data_model.g.dart';

@HiveType(typeId: AdapterId.noteId)
class NoteDataModel {
  NoteDataModel(
    this.id,
    this.title,
    this.text,
    this.dateOfLastChange,
    this.controllerMap,
  );

  @HiveField(0)
  final int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String text;

  @HiveField(3)
  String dateOfLastChange;

  @HiveField(4)
  Map<String, dynamic>? controllerMap;

  Note toNote() {
    final note = Note(
      id: id,
      title: title,
      text: text,
      dateOfLastChange: DateTime.parse(dateOfLastChange),
      controllerMap: controllerMap,
    );
    return note;
  }

  static NoteDataModel fromNote(Note note, int key) {
    final noteDataModel = NoteDataModel(
      key,
      note.title,
      note.text,
      note.dateOfLastChange.toString(),
      note.controllerMap,
    );
    return noteDataModel;
  }
}
