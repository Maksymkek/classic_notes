import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

class DropDownMenuState {
  DropDownMenuState({required this.items, required this.dy});

  final List<DropDownItem> items;
  final double dy;
}
