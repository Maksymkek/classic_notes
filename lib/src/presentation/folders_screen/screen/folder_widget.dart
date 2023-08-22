import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/extensions/date_time_extension.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_shadow.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_screen_widget.dart';

class FolderWidget extends StatefulWidget {
  const FolderWidget({
    super.key,
    required this.folder,
    this.previewMode = false,
  });

  final bool previewMode;
  final Folder folder;

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animation;
  late final AnimationController controller;
  final double size = 52;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!widget.previewMode) {
          controller.forward();
          Navigator.of(context)
              .pushNamed(NotesScreenWidget.screenName, arguments: widget.folder)
              .whenComplete(() {
            if (!controller.isDismissed) {
              try {
                if (!controller.isDismissed) {
                  controller.reverse();
                }
              } catch (_) {}
            }
          });
        }
      },
      onTapDown: (details) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
      child: Container(
        height: size,
        width: double.maxFinite,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.maxFinite,
                  width: size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.folder.background,
                    boxShadow: widget.previewMode ? [AppShadow.baseShadow] : [],
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: widget.folder.icon,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: size,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow:
                          widget.previewMode ? [AppShadow.baseShadow] : [],
                      color: widget.previewMode
                          ? AppColors.white
                          : animation.value,
                    ),
                    child: Text(
                      widget.folder.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.middleStyle,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 2.0),
                child: Text(
                  widget.folder.dateOfLastChange.getDateTimeString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.extraSmallStyle
                      .copyWith(color: AppColors.hintGrey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
      reverseDuration: const Duration(seconds: 1),
    );
    animation = ColorTween(
      begin: AppColors.light,
      end: AppColors.lightPressedGrey,
    ).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
