import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_screen_cubit.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

/// Cubit extension for [NoteScreenCubit] and [FolderScreenCubit]
abstract class ScreenCubit<Entity extends Item,
    State extends ScreenState<Entity>> extends Cubit<State> {
  ScreenCubit(super.initialState);

  /// DropDownItems for dropdown menu
  List<DropDownItem>? dropDownItems;

  /// cubit method to implement for reorder callback
  void onItemDragged(int oldItemIndex, int newItemIndex);

  /// initialize [dropDownItems] list if it's null
  void initSettingItems() {
    dropDownItems ??= [
      DropDownItem(
        title: LocaleKeys.sortBy.tr(),
        icon: AppIcons.listDash,
        iconSize: 14.5,
        actions: [
          DropDownAction(
            title: LocaleKeys.date.tr(),
            onTap: (context) => onSortByChanged(SortBy.date),
            isSelected: state.settings.sortBy == SortBy.date,
            icon: AppIcons.calendar,
          ),
          DropDownAction(
            title: LocaleKeys.name.tr(),
            onTap: (context) => onSortByChanged(SortBy.name),
            isSelected: state.settings.sortBy == SortBy.name,
            icon: AppIcons.textFormat,
          ),
          DropDownAction(
            title: LocaleKeys.custom.tr(),
            onTap: (context) => onSortByChanged(SortBy.custom),
            isSelected: state.settings.sortBy == SortBy.custom,
            icon: AppIcons.pencil,
          ),
        ],
      ),
      DropDownItem(
        title: LocaleKeys.sortOrder.tr(),
        icon: AppIcons.arrowsUpDown,
        iconSize: 13,
        actions: [
          DropDownAction(
            title: LocaleKeys.descending.tr(),
            onTap: (context) => onSortOrderChanged(SortOrder.descending),
            isSelected: state.settings.sortOrder == SortOrder.descending,
            icon: AppIcons.arrowDown,
            iconSize: 13,
          ),
          DropDownAction(
            title: LocaleKeys.ascending.tr(),
            onTap: (context) => onSortOrderChanged(SortOrder.ascending),
            isSelected: state.settings.sortOrder == SortOrder.ascending,
            icon: AppIcons.arrowUp,
            iconSize: 13,
          )
        ],
      ),
    ];
  }

  /// function to reorder items which returns [Map] of them
  Map<int, Entity>? updateItemOrder(int oldItemIndex, int newItemIndex) {
    if (oldItemIndex != newItemIndex &&
        state.settings.sortBy == SortBy.custom) {
      Map<int, Entity> newItems = {};
      for (int i = 0; i < state.items.length; i++) {
        if (i == newItemIndex) {
          newItems[i] = state.items[oldItemIndex]!;
          continue;
        }
        if (oldItemIndex > newItemIndex) {
          if (i < newItemIndex || i > oldItemIndex) {
            newItems[i] = state.items[i]!;
          } else if (i <= oldItemIndex) {
            newItems[i] = state.items[i - 1]!;
            continue;
          }
        } else {
          if (i > newItemIndex || i < oldItemIndex) {
            newItems[i] = state.items[i]!;
          } else if (i >= oldItemIndex) {
            newItems[i] = state.items[i + 1]!;
            continue;
          }
        }
      }
      return newItems;
    }
    return null;
  }

  int getMapKey(Entity entity) {
    int searchedKey = -1;
    state.items.forEach((key, value) {
      if (value.id == entity.id) {
        searchedKey = key;
        return;
      }
    });
    return searchedKey;
  }

  Map<int, Entity> reindexMap(Map<int, Entity> map) {
    Map<int, Entity> reindexedMap = {};
    int i = 0;
    for (var value in map.values) {
      reindexedMap[i] = value;
      i += 1;
    }
    return reindexedMap;
  }

  int getId() {
    final idList = state.items.values.map((e) => e.id).toList();
    if (idList.isEmpty) {
      return 0;
    }
    idList.sort();
    var newId = idList.last + 1;
    return newId;
  }

  void onSortByChanged(SortBy sortBy);

  void onSortOrderChanged(SortOrder sortOrder);
}
