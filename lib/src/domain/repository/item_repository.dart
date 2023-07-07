import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/settings_repository.dart';

abstract class ItemRepository<Entity extends Item>
    implements SettingsRepository {
  Future<Map<int, Entity>?> getItems();

  Future<void> addItem(Entity item);

  Future<void> updateItem(Entity item);

  Future<void> deleteItem(Entity item);

  Future<void> updateItemsOrder(Map<int, Entity> items);
}
