import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class DeleteItemInteractor<Entity extends Item> {
  DeleteItemInteractor(this.itemRepository);

  ItemRepository<Entity> itemRepository;

  Future<void> call(Entity item) async {
    await itemRepository.deleteItem(item);
  }
}
