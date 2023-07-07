import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_item/dropdown_item_list.dart';

class DropDownOverlayManager {
  DropDownOverlayManager._();

  static late OverlayState _overlayState;
  static OverlayEntry? _overlayEntry;
  static AnimationController? _otherController;

  static void buildOverlay({
    required BuildContext context,
    AnimationController? otherController,
    required List<DropDownItem> dropDownItems,
  }) {
    _otherController = otherController;
    _overlayState = Overlay.of(context);
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset(0, box.constraints.maxHeight));
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: AppColors.transparent,
          child: Align(
            child: DropDownItemListWidget(
              onClose: _removeHighlightOverlay,
              overlayState: _overlayState,
              dropDownItems: dropDownItems,
              parentPosition: position,
            ),
          ),
        );
      },
    );
    _otherController?.forward();
    _overlayState.insert(_overlayEntry!);
  }

  static Future<void> _removeHighlightOverlay() async {
    _otherController?.reverse();

    dispose();
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
