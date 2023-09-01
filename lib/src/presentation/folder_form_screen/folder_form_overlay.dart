import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

class FolderFormOverlayManager {
  FolderFormOverlayManager._();

  static late OverlayState _overlayState;
  static OverlayEntry? _overlayEntry;

  static void buildOverlay({
    required BuildContext context,
    Folder? folder,
  }) {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: AppColors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FolderFormWidget(
              folder: folder ??
                  Folder(
                    id: -1,
                    title: 'Quick Notes',
                    background: AppColors.darkBrown,
                    icon: const Icon(
                      AppIcons.folder,
                      color: AppColors.seashellWhite,
                      size: 28,
                    ),
                    dateOfLastChange: DateTime.now(),
                  ),
              onClose: dispose,
              onDone: folder != null
                  ? ServiceLocator.getInstance()
                      .folderScreenCubit
                      .onUpdateFolderClick
                  : ServiceLocator.getInstance()
                      .folderScreenCubit
                      .onAddFolderClick,
            ),
          ),
        );
      },
    );

    _overlayState.insert(_overlayEntry!);
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
