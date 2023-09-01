import 'package:notes/src/data/datasource/items/data_source.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class ItemRepositoryImpl<Entity extends Item,
        EntityDataSource extends DataSource<Entity>>
    implements ItemRepository<Entity> {
  ItemRepositoryImpl(this._dataSource);

  final EntityDataSource _dataSource;

  @override
  Future<void> addItem(Entity item) async {
    await _dataSource.putItem(item);
  }

  @override
  Future<void> deleteItem(Entity item) async {
    await _dataSource.deleteItem(item);
  }

  @override
  Future<Map<int, Entity>?> getItems() async {
    return await _dataSource.getItems();
  }

  @override
  Future<void> updateItem(Entity item) async {
    await _dataSource.putItem(item);
  }

  @override
  Future<void> updateItemsOrder(Map<int, Entity> items) async {
    await _dataSource.putItems(items);
  }

  @override
  Future<ItemSettingsModel> getSetting() async {
    return await _dataSource.settings.readSettings();
  }

  @override
  Future<void> setSetting(ItemSetting setting) async {
    await _dataSource.settings.writeSetting(setting);
  }

  @override
  Future<void> deleteAll() async {
    await _dataSource.deleteAll();
  }
}
