import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/app_text_button.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/app_toggle_button.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/screen/action_bar/action_row_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/action_bar/color_action_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/note_action_widget.dart';

class ActionBarWidget extends StatefulWidget {
  const ActionBarWidget({
    super.key,
    required this.color,
    required this.cubit,
    required this.animation,
  });

  final Color color;
  final Animation<double> animation;
  final NoteFormCubit cubit;

  @override
  State<ActionBarWidget> createState() => _ActionBarWidgetState();
}

class _ActionBarWidgetState extends State<ActionBarWidget> {
  bool isExpanded = false;
  Color pickerColor = AppColors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDrag,
      child: SizeTransition(
        sizeFactor: widget.animation,
        axis: Axis.vertical,
        axisAlignment: 1.0,
        child: Column(
          children: [
            AppIconButtonWidget(
              icon: isExpanded
                  ? CupertinoIcons.chevron_compact_up
                  : CupertinoIcons.chevron_compact_down,
              onPressed: () {
                isExpanded = isExpanded == false;
                setState(() {});
              },
              color: AppColors.darkBrown,
              activeColor: AppColors.lightBrown,
              iconSize: 26,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                buildExpandedPanel(),
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 41.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.color,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.chevron_left,
                        onPressed: widget.cubit.onUndoClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        startToggled: true,
                        isToggled: () {
                          return !widget.cubit.state.bufferStatus.canUndo;
                        },
                      ),
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.increase_indent,
                        onPressed: widget.cubit.onIndentClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        isToggled: () {
                          return false;
                        },
                      ),
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.list_number,
                        onPressed: widget.cubit.onNumListClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        isToggled: () {
                          return widget.cubit.state.listStatus ==
                              ListStatus.enumerated;
                        },
                      ),
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.list_bullet,
                        onPressed: widget.cubit.onDotListClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        isToggled: () {
                          return widget.cubit.state.listStatus ==
                              ListStatus.dotted;
                        },
                      ),
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.list_bullet_indent,
                        onPressed: widget.cubit.onSubListClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        isToggled: () {
                          return widget.cubit.state.listStatus ==
                              ListStatus.sublist;
                        },
                      ),
                      AppToggleButtonWidget(
                        icon: CupertinoIcons.chevron_right,
                        onPressed: widget.cubit.onRedoClicked,
                        color: AppColors.darkBrown,
                        activeColor: AppColors.lightBrown,
                        iconSize: 28,
                        cubit: widget.cubit,
                        startToggled: true,
                        isToggled: () {
                          return !widget.cubit.state.bufferStatus.canRedo;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandedPanel() {
    return AnimatedContainer(
      padding: EdgeInsets.only(top: 12.0, bottom: isExpanded ? 42 : 0),
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isExpanded ? 20.0 : 0.0),
        ),
      ),
      curve: Curves.fastOutSlowIn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          ActionsRowWidget(
            cubit: widget.cubit,
            actions: [
              NoteActionWidget(
                icon: CupertinoIcons.eyedropper,
                iconSize: 26,
                onPressed: () {
                  colorPickerDialog().whenComplete(
                    () => widget.cubit.onMetadataButtonPressed(
                      MetadataValue.color,
                      color: pickerColor,
                    ),
                  );
                },
              ),
              const VerticalDivider(
                color: AppColors.darkBrown,
                thickness: 1.0,
                width: 1.0,
              ),
              ColorActionWidget(cubit: widget.cubit, pickerColor: pickerColor)
            ],
          ),
          ActionsRowWidget(
            cubit: widget.cubit,
            actions: [
              NoteActionWidget(
                icon: CupertinoIcons.italic,
                iconSize: 28,
                onPressed: () {
                  widget.cubit.onMetadataButtonPressed(MetadataValue.italic);
                },
              ),
              //const SizedBox(width: 3),
              const VerticalDivider(
                color: AppColors.darkBrown,
                thickness: 1.0,
                width: 1.0,
              ),
              NoteActionWidget(
                icon: CupertinoIcons.bold,
                iconSize: 28,
                onPressed: () {
                  widget.cubit.onMetadataButtonPressed(MetadataValue.bold);
                },
              ),
              //const SizedBox(width: 3),
              const VerticalDivider(
                color: AppColors.darkBrown,
                thickness: 1.0,
                width: 1.0,
              ),
              NoteActionWidget(
                icon: CupertinoIcons.underline,
                iconSize: 28,
                onPressed: () {
                  widget.cubit.onMetadataButtonPressed(MetadataValue.underline);
                },
              ),
              const VerticalDivider(
                color: AppColors.darkBrown,
                thickness: 1.0,
                width: 1.0,
              ),
              NoteActionWidget(
                icon: CupertinoIcons.strikethrough,
                iconSize: 28,
                onPressed: () {
                  widget.cubit
                      .onMetadataButtonPressed(MetadataValue.strikeThrough);
                },
              ),
            ],
          ),
          ActionsRowWidget(
            cubit: widget.cubit,
            actions: [
              NoteActionWidget(
                icon: CupertinoIcons.chevron_up,
                iconSize: 28,
                onPressed: () {
                  widget.cubit
                      .onMetadataButtonPressed(MetadataValue.headerText);
                },
              ),
              const VerticalDivider(
                color: AppColors.darkBrown,
                thickness: 1.0,
                width: 1.0,
              ),
              NoteActionWidget(
                icon: CupertinoIcons.clear,
                iconSize: 28,
                onPressed: () {
                  widget.cubit.onMetadataButtonPressed(MetadataValue.baseText);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onVerticalDrag(dragDetails) {
    if (dragDetails.delta.dy > 0) {
      isExpanded = false;
    } else if (dragDetails.delta.dy < 0) {
      isExpanded = true;
    }
    setState(() {});
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future colorPickerDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              top: 0.0,
              right: 30.0,
              bottom: 0.0,
            ),
            child: AppTextButtonWidget(
              icon: CupertinoIcons.check_mark,
              text: 'Done',
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}
