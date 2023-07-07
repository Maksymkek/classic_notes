import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

class GetItemsInteractor<Entity extends Item> {
  GetItemsInteractor(this.itemRepository);

  ItemRepository<Entity> itemRepository;

  Future<Map<int, Entity>?> call() async {
    return itemRepository.getItems();
  }
}
