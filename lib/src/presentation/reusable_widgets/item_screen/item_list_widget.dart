import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/presentation/interfaces/screen_cubit.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';
import 'package:notes/src/presentation/reusable_widgets/draggable_item/custom_drag_item.dart';

class ItemListWidget<Entity extends Item, ItemState extends ScreenState<Entity>,
    ItemCubit extends ScreenCubit<Entity, ItemState>> extends StatefulWidget {
  const ItemListWidget({
    super.key,
    required this.cubit,
    required this.actionsWidget,
  });

  // ignore: require_trailing_commas
  final Widget Function(
    Entity,
    ItemCubit, {
    Key? key,
  }) actionsWidget;
  final ItemCubit cubit;

  @override
  _ItemListWidgetState createState() =>
      _ItemListWidgetState<Entity, ItemState, ItemCubit>();
}

class _ItemListWidgetState<
        Entity extends Item,
        ItemState extends ScreenState<Entity>,
        ItemCubit extends ScreenCubit<Entity, ItemState>>
    extends State<ItemListWidget<Entity, ItemState, ItemCubit>> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
        child: DragAndDropLists(
          itemGhostOpacity: 0.0,
          onItemReorder: (
            int oldItemIndex,
            int oldListIndex,
            int newItemIndex,
            int newListIndex,
          ) {
            widget.cubit.onItemDragged(oldItemIndex, newItemIndex);
          },
          onListReorder: (int oldListIndex, int newListIndex) {},
          children: [
            DragAndDropList(
              children: buildActionWidgetList(),
            ),
          ],
        ),
      ),
    );
  }

  List<DragAndDropItem> buildActionWidgetList() {
    var itemsMap = widget.cubit.state.items.map((key, item) {
      return MapEntry(
        key,
        CustomDragAndDropItem(
          child: widget.actionsWidget(item, widget.cubit),
          name: item.title,
          dateOfLastChange: item.dateOfLastChange,
        ),
      );
    });
    List<CustomDragAndDropItem> sortedItems = sortItems(
      itemsMap,
      widget.cubit.state.settings.sortOrder,
      widget.cubit.state.settings.sortBy,
    );
    return sortedItems;
  }

  List<CustomDragAndDropItem> sortItems(
    Map<int, CustomDragAndDropItem> itemsMap,
    SortOrder sortOrder,
    SortBy sortBy,
  ) {
    var sortedItems = itemsMap.values.toList();
    if (sortBy != SortBy.custom) {
      sortedItems.sort((a, b) {
        if (sortBy == SortBy.name) {
          return a.name.compareTo(b.name);
        } else {
          return a.dateOfLastChange.compareTo(b.dateOfLastChange);
        }
      });
      if (sortOrder == SortOrder.descending) {
        return sortedItems.reversed.toList();
      }
    }
    return sortedItems;
  }
}
