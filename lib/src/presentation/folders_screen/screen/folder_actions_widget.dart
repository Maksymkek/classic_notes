import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/slidable_action.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_widget.dart';

class FolderActionsWidget extends StatelessWidget {
  const FolderActionsWidget({
    super.key,
    required this.folder,
    required this.cubit,
    required this.animationController,
    required this.animation,
  });

  final FolderPageCubit cubit;
  final Folder folder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) =>
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Slidable(
          key: ValueKey(folder.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () async {
                await cubit.onDeleteFolderClick(folder);
              },
            ),
            extentRatio: 0.5,
            children: [
              SlidableActionWidget(
                icon: CupertinoIcons.pencil,
                color: AppColors.brightBlue,
                onTap: () {
                  FolderFormOverlayManager.buildOverlay(
                    context: context,
                    animation: animation,
                    folder: folder,
                    animationController: animationController,
                  );
                },
              ),
              SlidableActionWidget(
                icon: CupertinoIcons.delete_simple,
                color: AppColors.carmineRed,
                onTap: () async {
                  await cubit.onDeleteFolderClick(folder);
                },
              ),
            ],
          ),
          child: FolderWidget(
            folder: folder,
          ),
        ),
      ),
    );
  }
}
