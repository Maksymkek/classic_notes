import 'package:notes/src/data/datasource/settings/item_settings/local/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/item/item.dart';

abstract class DataSource<Entity extends Item> {
  DataSource();

  late final ItemSettingsDataSource settings;

  Future<Map<int, Entity>> getItems();

  Future<void> putItems(Map<int, Entity> items);

  Future<void> putItem(Entity item);

  Future<void> deleteItem(Entity item);

  Future<void> deleteAll();
}
