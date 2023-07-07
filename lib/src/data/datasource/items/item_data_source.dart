import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/data_model/item/item_data_model.dart';
import 'package:notes/src/domain/entity/item/item.dart';

class ItemDataSource<DataModel extends ItemDataModel, Entity extends Item> {
  late Box<DataModel> box;
  late final String _boxName;
  final DataModel Function(Entity, int) fromItem;

  ItemDataSource(
    this._boxName,
    this.fromItem,
  );

  Future<Map<int, Entity>> getItems() async {
    box = await Hive.openBox<DataModel>(_boxName);
    final mapFrom = box.keys.toList();
    Map<int, Entity> items = {};
    for (int i = 0; i < mapFrom.length; i++) {
      items[i] = box.get(mapFrom[i])!.toItem() as Entity;
    }
    await box.close();
    return items;
  }

  Future<void> putItems(Map<int, Entity> items) async {
    box = await Hive.openBox<DataModel>(_boxName);
    final Map<int, DataModel> itemModels = items.map(
      (key, item) => MapEntry(key, fromItem(item, item.id)),
    );
    await box.putAll(itemModels);
    await box.close();
  }

  Future<void> putItem(Entity item) async {
    box = await Hive.openBox<DataModel>(_boxName);
    int id = item.id;
    int key = _indexOf(item);
    if (id == -1) {
      id = _getId();
      key = box.keys.length;
    }
    await box.put(key, fromItem(item, id));
    await box.close();
  }

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

  int _getId() {
    final idList = box.values.map((e) => e.id).toList();
    if (idList.isEmpty) {
      return 0;
    }
    idList.sort();
    var newId = idList.last + 1;
    return newId;
  }

  int _indexOf(Entity item) {
    int i = 0;
    for (var value in box.values) {
      if (value.id == item.id) {
        return i;
      }
      i += 1;
    }
    return -1;
  }
}
