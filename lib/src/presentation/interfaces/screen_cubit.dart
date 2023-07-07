import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

/// Cubit extension for [NotePageCubit] and [FolderPageCubit]
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
        title: 'Sort by',
        icon: AppIcons.listDash,
        iconSize: 14.5,
        actions: [
          DropDownAction(
            title: SortBy.date.name,
            onTap: () => onSortByChanged(SortBy.date),
            isSelected: state.settings.sortBy == SortBy.date,
            icon: AppIcons.calendar,
          ),
          DropDownAction(
            title: SortBy.name.name,
            onTap: () => onSortByChanged(SortBy.name),
            isSelected: state.settings.sortBy == SortBy.name,
            icon: AppIcons.textFormat,
          ),
          DropDownAction(
            title: SortBy.custom.name,
            onTap: () => onSortByChanged(SortBy.custom),
            isSelected: state.settings.sortBy == SortBy.custom,
            icon: AppIcons.pencil,
          ),
        ],
      ),
      DropDownItem(
        title: 'Sort order',
        icon: AppIcons.arrowsUpDown,
        iconSize: 13,
        actions: [
          DropDownAction(
            title: SortOrder.descending.name,
            onTap: () => onSortOrderChanged(SortOrder.descending),
            isSelected: state.settings.sortOrder == SortOrder.descending,
            icon: AppIcons.arrowDown,
            iconSize: 13,
          ),
          DropDownAction(
            title: SortOrder.ascending.name,
            onTap: () => onSortOrderChanged(SortOrder.ascending),
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

  void onSortByChanged(SortBy sortBy);

  void onSortOrderChanged(SortOrder sortOrder);
}
