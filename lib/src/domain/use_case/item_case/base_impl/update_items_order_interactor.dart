import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/use_case/item_case/item_interactor.dart';

base class UpdateItemsOrderInteractor<Entity extends Item>
    extends ItemInteractor<Entity> {
  UpdateItemsOrderInteractor(super.itemRepository);

  Future<void> call(Map<int, Entity> items) async {
    await itemRepository.updateItemsOrder(items);
  }
}
