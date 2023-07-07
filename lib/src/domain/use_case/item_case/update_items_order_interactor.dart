import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class UpdateItemsOrderInteractor<Entity extends Item> {
  UpdateItemsOrderInteractor(this.itemRepository);

  ItemRepository<Entity> itemRepository;

  Future<void> call(Map<int, Entity> items) async {
    await itemRepository.updateItemsOrder(items);
  }
}
