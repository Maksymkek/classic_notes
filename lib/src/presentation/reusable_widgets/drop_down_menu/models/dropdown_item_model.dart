import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/item_interface.dart';

class DropDownItem extends Equatable {
  DropDownItem({
    required this.title,
    required this.icon,
    required this.actions,
    this.isActive = false,
    this.iconSize,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final List<DropDownAction> actions;
  final double? iconSize;
  final Function()? onTap;
  bool isActive;
  ItemState visualState = ActiveItemState.getInstance();
  Color? tapResponseColor;

  static DropDownItem from(DropDownItem item) {
    var newActions =
        item.actions.map((action) => DropDownAction.from(action)).toList();
    var newItem = DropDownItem(
      title: item.title,
      icon: item.icon,
      actions: newActions,
      onTap: item.onTap,
      iconSize: item.iconSize,
    );
    newItem.visualState = item.visualState;
    newItem.isActive = item.isActive;
    newItem.tapResponseColor = item.tapResponseColor;
    return newItem;
  }

  @override
  List<Object?> get props =>
      [title, icon, tapResponseColor, isActive, visualState];
}
