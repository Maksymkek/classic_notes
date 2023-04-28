import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/data_model/note_data_model.dart';
import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';

class NoteDataSource {
  NoteDataSource(Folder folder) {
    _boxName = getBoxName(folder);
    checkAdapter();
  }

  late final String _boxName;
  late Box<NoteDataModel> box;
  final ItemSettingsDataSource settings =
      ItemSettingsDataSource(boxName: 'note_settings');

  static String getBoxName(Folder folder) => 'folder_${folder.id}_note_box';

  static void checkAdapter() {
    final noteDataModelAdapter = NoteDataModelAdapter();
    if (!Hive.isAdapterRegistered(noteDataModelAdapter.typeId)) {
      Hive.registerAdapter(noteDataModelAdapter);
    }
  }

  Future<Map<int, Note>> getNotes() async {
    box = await Hive.openBox<NoteDataModel>(_boxName);
    final mapFrom = box.keys.toList();
    Map<int, Note> notes = {};
    for (int i = 0; i < mapFrom.length; i++) {
      notes[i] = box.get(mapFrom[i])!.toNote();
    }
    await box.close();
    return notes;
  }

  Future<void> putNotes(Map<int, Note> notes) async {
    box = await Hive.openBox<NoteDataModel>(_boxName);
    final Map<int, NoteDataModel> noteModels = notes.map(
      (key, note) => MapEntry(key, NoteDataModel.fromNote(note, note.id)),
    );
    await box.putAll(noteModels);
    await box.close();
  }

  Future<void> putNote(Note note) async {
    final updatedNote = note.copyWith(dateOfLastChange: DateTime.now());
    box = await Hive.openBox<NoteDataModel>(_boxName);
    int id = updatedNote.id;
    int key = _indexOf(note);
    if (id == -1) {
      id = _getId(box);
      key = box.keys.length;
    }
    await box.put(key, NoteDataModel.fromNote(updatedNote, id));
    await box.close();
  }

  Future<void> deleteNote(Note note) async {
    box = await Hive.openBox<NoteDataModel>(_boxName);
    await box.delete(_indexOf(note));
    var values = box.values.toList();
    await box.deleteAll(box.keys);
    for (int i = 0; i < values.length; i += 1) {
      await box.put(i, values[i]);
    }
    await box.close();
  }

  int _getId(Box<NoteDataModel> box) {
    final idList = box.values.map((e) => e.id).toList();
    if (idList.isEmpty) {
      return 0;
    }
    idList.sort();
    var newId = idList.last + 1;
    return newId;
  }

  int _indexOf(Note note) {
    int i = 0;
    for (var value in box.values) {
      if (value.id == note.id) {
        return i;
      }
      i += 1;
    }
    return -1;
  }
}
