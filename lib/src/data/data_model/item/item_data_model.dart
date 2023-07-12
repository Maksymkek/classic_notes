import 'package:notes/src/domain/entity/item/item.dart';

abstract class ItemDataModel<Entity extends Item> {
  ItemDataModel(this.id, this.dateOfLastChange);

  final int id;

  final String dateOfLastChange;

  Entity toItem();
}
