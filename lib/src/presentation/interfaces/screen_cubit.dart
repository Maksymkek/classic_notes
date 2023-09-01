import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/data/repository/note_repository_impl.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/extensions/map_extension.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/domain/repository/item_repository.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/add_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/get_items_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/update_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/update_items_order_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/folder_impl/delete_folder_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/note_impl/add_note_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/note_impl/delete_note_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/note_impl/update_note_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_setting_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_setting_interactor.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_screen_state.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_state.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

part 'package:notes/src/presentation/folders_screen/cubit/folder_screen_cubit.dart';
part 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';

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

  /// function to reorder items which returns [Map] of them or null if [state.settings.sortBy] not [SortBy.custom]
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

  Map<int, Entity> _addItem(Entity item) {
    return HashMap.from(state.items)..[state.items.length] = item;
  }

  Map<int, Entity> _updateItem(Entity item) {
    return HashMap.from(state.items)
      ..update(
        state.items.getMapKey(item),
        (value) => item,
      );
  }

  Map<int, Entity> _deleteItem(Entity item) {
    return HashMap.from(state.items)
      ..removeWhere((key, value) => value.id == item.id);
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

  void onSortByChanged(SortBy sortBy);

  void onSortOrderChanged(SortOrder sortOrder);
}
