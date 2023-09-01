import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/use_case/item_case/item_interactor.dart';

base class UpdateItemInteractor<Entity extends Item>
    extends ItemInteractor<Entity> {
  UpdateItemInteractor(super.itemRepository);

  Future<void> call(Entity item) async {
    await itemRepository.updateItem(item);
  }
}
