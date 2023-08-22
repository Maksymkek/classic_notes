import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/icon_button.dart';

class FolderFormButtonWidget extends StatelessWidget {
  const FolderFormButtonWidget({super.key, this.folder});

  final Folder? folder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7.0, bottom: 5.0),
      child: AppIconButtonWidget(
        icon: AppIcons.addFolder,
        activeColor: AppColors.lightToggledGrey,
        onPressed: () => FolderFormOverlayManager.buildOverlay(
          context: context,
        ),
        iconSize: 48,
        color: AppColors.darkGrey,
      ),
    );
  }
}
