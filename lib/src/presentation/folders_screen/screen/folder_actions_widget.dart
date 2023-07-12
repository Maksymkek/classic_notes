import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/slidable_action/slidable_action.dart';

class FolderActionsWidget extends StatelessWidget {
  const FolderActionsWidget(
    this.item,
    this.cubit, {
    super.key,
  });

  final FolderPageCubit cubit;
  final Folder item;

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) =>
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Slidable(
          key: ValueKey(item.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () async {
                await cubit.onDeleteFolderClick(item);
              },
            ),
            extentRatio: 0.5,
            children: [
              SlidableActionWidget(
                icon: AppIcons.pencil,
                color: AppColors.brightBlue,
                onTap: () {
                  FolderFormOverlayManager.buildOverlay(
                    context: context,
                    folder: item,
                  );
                },
              ),
              SlidableActionWidget(
                icon: AppIcons.trashBox,
                color: AppColors.carmineRed,
                onTap: () async {
                  await cubit.onDeleteFolderClick(item);
                },
              ),
            ],
          ),
          child: FolderWidget(
            folder: item,
          ),
        ),
      ),
    );
  }
}
