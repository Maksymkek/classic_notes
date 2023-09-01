import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/data_model/folder/folder_data_model.dart';
import 'package:notes/src/data/data_model/item/item_data_model.dart';
import 'package:notes/src/data/data_model/note/note_data_model.dart';
import 'package:notes/src/data/datasource/items/data_source.dart';
import 'package:notes/src/data/datasource/settings/item_settings/local/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/item/item.dart';

class LocalItemDataSource<Entity extends Item,
    DataModel extends ItemDataModel<Entity>> implements DataSource<Entity> {
  LocalItemDataSource(
    this._boxName,
    this.fromItem,
    String settingsBoxName,
  ) {
    settings = ItemSettingsDataSource(settingsBoxName);
    checkFolderAdapter();
    checkNoteAdapter();
  }

  late Box<DataModel> box;
  late final String _boxName;
  @override
  late final ItemSettingsDataSource settings;
  final DataModel Function(Entity, int) fromItem;

  /// Need to check without polymorphysm
  void checkFolderAdapter() {
    final folderAdapter = FolderDataModelAdapter();
    if (!Hive.isAdapterRegistered(folderAdapter.typeId)) {
      Hive.registerAdapter(folderAdapter);
    }
  }

  void checkNoteAdapter() {
    final noteAdapter = NoteDataModelAdapter();
    if (!Hive.isAdapterRegistered(noteAdapter.typeId)) {
      Hive.registerAdapter(noteAdapter);
    }
  }

  @override
  Future<Map<int, Entity>> getItems() async {
    box = await Hive.openBox<DataModel>(_boxName);
    final mapFrom = box.keys.toList();
    Map<int, Entity> items = {};
    for (int i = 0; i < mapFrom.length; i++) {
      items[i] = box.get(mapFrom[i])!.toItem();
    }
    await box.close();
    return items;
  }

  @override
  Future<void> putItems(Map<int, Entity> items) async {
    box = await Hive.openBox<DataModel>(_boxName);
    final Map<int, DataModel> itemModels = items.map(
      (key, item) => MapEntry(key, fromItem(item, item.id)),
    );
    await box.putAll(itemModels);
    await box.close();
  }

  @override
  Future<void> putItem(Entity item) async {
    box = await Hive.openBox<DataModel>(_boxName);
    int key = _indexOf(item);
    await box.put(key, fromItem(item, item.id));
    await box.close();
  }

  @override
  Future<void> deleteItem(Entity item) async {
    box = await Hive.openBox<DataModel>(_boxName);
    await box.delete(_indexOf(item));
    var values = box.values.toList();
    await box.deleteAll(box.keys);
    for (int i = 0; i < values.length; i += 1) {
      await box.put(i, values[i]);
    }
    await box.close();
  }

  @override
  Future<void> deleteAll() async {
    box = await Hive.openBox<DataModel>(_boxName);
    await box.deleteFromDisk();
  }

  int _indexOf(Entity item) {
    int i = 0;
    for (var value in box.values) {
      if (value.id == item.id) {
        return i;
      }
      i += 1;
    }
    return i;
  }
}
