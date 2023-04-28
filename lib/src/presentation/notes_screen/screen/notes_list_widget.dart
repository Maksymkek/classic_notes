import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/presentation/common_widgets/custom_drag_item.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_widget_actions.dart';

class NoteListWidget extends StatefulWidget {
  const NoteListWidget({super.key, required this.cubit});

  final NotePageCubit cubit;

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

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
              children: buildFolderActionWidgetList(widget.cubit),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  List<DragAndDropItem> buildFolderActionWidgetList(NotePageCubit cubit) {
    var itemsMap = cubit.state.notes.map((key, note) {
      return MapEntry(
        key,
        CustomDragAndDropItem(
          child: NoteActionsWidget(
            note: note,
            cubit: cubit,
            animationController: animationController,
            animation: animation,
          ),
          name: note.title,
          dateOfLastChange: note.dateOfLastChange,
        ),
      );
    });
    List<CustomDragAndDropItem> sortedItems =
        sortItems(itemsMap, cubit.state.sortOrder, cubit.state.sortBy);
    return sortedItems;
  }

  List<CustomDragAndDropItem> sortItems(
    Map<int, CustomDragAndDropItem> itemsMap,
    String sortOrder,
    String sortBy,
  ) {
    var sortedItems = itemsMap.values.toList();
    if (sortBy != SortBy.custom.name) {
      sortedItems.sort((a, b) {
        if (sortBy == SortBy.name.name) {
          return a.name.compareTo(b.name);
        } else {
          return a.dateOfLastChange.compareTo(b.dateOfLastChange);
        }
      });
      if (sortOrder == SortOrder.descending.name) {
        return sortedItems.reversed.toList();
      }
    }
    return sortedItems;
  }
}
