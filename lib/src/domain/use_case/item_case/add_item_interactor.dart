import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class AddItemInteractor<Entity extends Item> {
  AddItemInteractor(this.itemRepository);

  ItemRepository<Entity> itemRepository;

  Future<void> call(Entity item) async {
    await itemRepository.addItem(item);
  }
}
