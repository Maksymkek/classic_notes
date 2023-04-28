import 'package:flutter/material.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_item_list.dart';

class DropDownOverlayManager {
  DropDownOverlayManager._();

  static late OverlayState _overlayState;
  static OverlayEntry? _overlayEntry;
  static AnimationController? _otherController;
  static late AnimationController _menuController;

  static void buildOverlay({
    required BuildContext context,
    required Animation<double> animation,
    required AnimationController animationController,
    AnimationController? otherController,
    required List<DropDownItem> dropDownItems,
  }) {
    _menuController = animationController;
    _otherController = otherController;
    _overlayState = Overlay.of(context);
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset(0, box.constraints.maxHeight));
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: Colors.transparent,
          child: Align(
            child: DropDownItemListWidget(
              itemAnimation: animation,
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
    animationController.forward();
  }

  static Future<void> _removeHighlightOverlay() async {
    _otherController?.reverse();
    await _menuController.reverse();
    dispose();
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
