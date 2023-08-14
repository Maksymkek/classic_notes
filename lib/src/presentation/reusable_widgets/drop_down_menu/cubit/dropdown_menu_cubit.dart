import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/disabled_item.dart';

class DropDownMenuCubit extends Cubit<DropDownMenuState> {
  DropDownMenuCubit(List<DropDownItem> items, this.overlayState, double dy)
      : super(DropDownMenuState(items: items, dy: dy));

  final OverlayState overlayState;

  _copyWith({required List<DropDownItem> items}) {
    emit(DropDownMenuState(items: items, dy: state.dy));
  }

  void syncChangedSettings(List<DropDownItem> items) {
    for (int i = 0; i < items.length; i += 1) {
      var item = items[i];
      var newItem = state.items[i];
      for (int j = 0; j < item.actions.length; j += 1) {
        item.actions[j].isSelected = newItem.actions[j].isSelected;
      }
    }
  }

  void onActionSelected(DropDownAction selectedAction, BuildContext context) {
    if (selectedAction.isSelected == false) {
      selectedAction.onTap(context);
      List<DropDownItem> newItems = state.items.map((item) {
        var newItem = DropDownItem.from(item);
        if (newItem.actions.contains(selectedAction)) {
          _switchSelectedAction(newItem, selectedAction);
        }
        return newItem;
      }).toList();
      _copyWith(items: newItems);
    }
  }

  void _switchSelectedAction(
    DropDownItem item,
    DropDownAction selectedAction,
  ) {
    for (var action in item.actions) {
      if (action.isSelected) {
        action.isSelected = false;
      }
      if (action.title == selectedAction.title) {
        action.isSelected = true;
      }
    }
  }

  void onItemClick(DropDownItem selectedItem) {
    int id = getItemId(selectedItem);
    selectedItem.isActive = selectedItem.isActive ? false : true;
    final newItems = state.items.map((item) {
      if (state.items.indexOf(item) == id) {
        for (var action in selectedItem.actions) {}
        return selectedItem;
      } else {
        item.visualState = DisabledItemState.getInstance();
        item.isActive = false;
        return item;
      }
    }).toList();
    _copyWith(items: newItems);
  }

  void uncheckItem() {
    final newItems = state.items.map((item) {
      var newItem = DropDownItem.from(item);
      newItem.visualState = ActiveItemState.getInstance();
      newItem.isActive = false;

      return newItem;
    }).toList();
    _copyWith(items: newItems);
  }

  int _getActionId(DropDownAction action, DropDownItem item) {
    for (var oldAction in item.actions) {
      if (action.title == oldAction.title) {
        return item.actions.indexOf(oldAction);
      }
    }
    return -1;
  }

  int getItemId(DropDownItem item) {
    for (var oldItem in state.items) {
      if (item.title == oldItem.title) {
        return state.items.indexOf(oldItem);
      }
    }
    return -1;
  }
}
