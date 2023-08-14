import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/data_model/note/note_data_model.dart';
import 'package:notes/src/data/datasource/items/data_source.dart';
import 'package:notes/src/data/datasource/items/item_data_source.dart';
import 'package:notes/src/data/datasource/settings/item_settings/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/note.dart';

class NoteDataSource implements DataSource<Note> {
  NoteDataSource(Folder folder) {
    boxName = getBoxName(folder);
    checkAdapter();
    _dataSource = ItemDataSource(
      boxName,
      NoteDataModel.fromNote,
    );
  }

  late final ItemDataSource<Note, NoteDataModel> _dataSource;
  @override
  late final String boxName;

  @override
  ItemSettingsDataSource get settings =>
      ItemSettingsDataSource('note_settings');

  static String getBoxName(Folder folder) => 'folder_${folder.id}_note_box';

  static void checkAdapter() {
    final noteDataModelAdapter = NoteDataModelAdapter();
    if (!Hive.isAdapterRegistered(noteDataModelAdapter.typeId)) {
      Hive.registerAdapter(noteDataModelAdapter);
    }
  }

  @override
  Future<Map<int, Note>> getItems() async {
    return await _dataSource.getItems();
  }

  @override
  Future<void> putItems(Map<int, Note> notes) async {
    await _dataSource.putItems(notes);
  }

  @override
  Future<void> putItem(Note note) async {
    await _dataSource.putItem(note.copyWith(dateOfLastChange: DateTime.now()));
  }

  @override
  Future<void> deleteItem(Note note) async {
    await _dataSource.deleteItem(note);
  }
}
