import 'package:notes/src/data/datasource/items/data_source.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class ItemRepositoryImpl<Entity extends Item,
        EntityDataSource extends DataSource<Entity>>
    implements ItemRepository<Entity> {
  ItemRepositoryImpl(this._entityDataSource);

  final EntityDataSource _entityDataSource;

  @override
  Future<void> addItem(Entity item) async {
    await _entityDataSource.putItem(item);
  }

  @override
  Future<void> deleteItem(Entity item) async {
    await _entityDataSource.deleteItem(item);
  }

  @override
  Future<Map<int, Entity>?> getItems() async {
    return await _entityDataSource.getItems();
  }

  @override
  Future<void> updateItem(Entity item) async {
    await _entityDataSource.putItem(item);
  }

  @override
  Future<void> updateItemsOrder(Map<int, Entity> items) async {
    await _entityDataSource.putItems(items);
  }

  @override
  Future<ItemSettingsModel> getSetting() async {
    return await _entityDataSource.settings.readSettings();
  }

  @override
  Future<void> setSetting(ItemSetting setting) async {
    _entityDataSource.settings.writeSetting(setting);
  }
}
