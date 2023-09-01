import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/use_case/item_case/item_interactor.dart';

base class GetItemsInteractor<Entity extends Item>
    extends ItemInteractor<Entity> {
  GetItemsInteractor(super.itemRepository);

  Future<Map<int, Entity>?> call() async {
    return await itemRepository.getItems();
  }
}
