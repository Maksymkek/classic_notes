import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_item/dropdown_item_list.dart';

class DropDownOverlayManager {
  DropDownOverlayManager._();

  static OverlayEntry? _overlayEntry;
  static AnimationController? _buttonAnimationController;

  static void buildOverlay({
    required BuildContext context,
    AnimationController? buttonAnimationController,
    required List<DropDownItem> dropDownItems,
  }) {
    _buttonAnimationController = buttonAnimationController;

    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset(0, box.constraints.maxHeight));
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: AppColors.transparent,
          child: Align(
            child: DropDownItemListWidget(
              onClose: _removeHighlightOverlay,
              dropDownItems: dropDownItems,
              parentPosition: position,
            ),
          ),
        );
      },
    );
    _buttonAnimationController?.forward();
    Overlay.of(context).insert(_overlayEntry!);
  }

  static Future<void> _removeHighlightOverlay() async {
    _buttonAnimationController?.reverse();
    dispose();
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
