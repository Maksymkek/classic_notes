import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';

abstract class ScreenState<Entity extends Item> {
  ScreenState(this.items, this.settings);

  final Map<int, Entity> items;
  final ItemSettingsModel settings;
}
