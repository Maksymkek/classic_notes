import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';

class ItemSettingsModel {
  ItemSettingsModel(this.sortBy, this.sortOrder);

  final SortBy sortBy;
  final SortOrder sortOrder;
}
