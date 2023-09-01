import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/repository/item_repository.dart';

base class ItemInteractor<Entity extends Item> {
  ItemInteractor(this.itemRepository);

  final ItemRepository<Entity> itemRepository;
}
