import 'package:drag_and_drop_lists/drag_and_drop_item.dart';

class CustomDragAndDropItem extends DragAndDropItem {
  CustomDragAndDropItem({
    required this.name,
    required this.dateOfLastChange,
    required super.child,
  });

  final String name;
  final DateTime dateOfLastChange;
}
