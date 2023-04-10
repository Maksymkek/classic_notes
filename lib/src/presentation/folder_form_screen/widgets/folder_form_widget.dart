import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/common_widgets/appTextButton.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_preview_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/style_picker_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/text_field_widget.dart';

const Duration duration = Duration(milliseconds: 200);

final List<ColorPickerModel> _colorPickers = [
  ColorPickerModel(
    color: AppColors.sapphireBlue,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.lightYellow,
    iconColor: AppColors.darkBrown,
  ),
  ColorPickerModel(
    color: AppColors.darkGrey,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.lightBrown,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.darkBrown,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.seashellWhite,
    iconColor: AppColors.darkBrown,
  ),
  ColorPickerModel(
    color: AppColors.carmineRed,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.milkWhite,
    iconColor: AppColors.darkBrown,
  )
];
final List<IconPickerModel> _iconPickers = [
  IconPickerModel(icon: AppIcons.folder, iconSize: 20, trueIconSize: 28),
  IconPickerModel(icon: AppIcons.music, iconSize: 22, trueIconSize: 34),
  IconPickerModel(icon: AppIcons.medicine, iconSize: 18, trueIconSize: 24),
  IconPickerModel(icon: AppIcons.selected, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.media, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.book, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.time, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.newNote, iconSize: 22, trueIconSize: 32)
];

final BoxShadow shadow = BoxShadow(
  color: Colors.black.withOpacity(0.23),
  spreadRadius: 0,
  blurRadius: 5,
  offset: const Offset(0, 0), // changes position of shadow
);

class FolderFormWidget extends StatefulWidget {
  const FolderFormWidget({
    super.key,
    required this.onClose,
    required this.animation,
    required this.folder,
    required this.onDone,
    required this.animationController,
  });

  final AnimationController animationController;
  final Future<void> Function(AnimationController) onClose;
  final Animation<double> animation;
  final Folder folder;
  final Function(Folder) onDone;

  @override
  State<FolderFormWidget> createState() => _FolderFormWidgetState();
}

class _FolderFormWidgetState extends State<FolderFormWidget> {
  late FolderFormCubit cubit;

  @override
  void initState() {
    super.initState();
    _setStylePickerData();
    cubit = FolderFormCubit(
      FolderFormState(
        folder: Folder(
          id: widget.folder.id,
          icon: widget.folder.icon,
          name: widget.folder.name,
          background: widget.folder.background,
          dateOfCreation: widget.folder.dateOfCreation,
        ),
        colorPickers: _colorPickers,
        iconPickers: _iconPickers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClose(widget.animationController),
      child: FadeTransition(
        opacity: widget.animation,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.05),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizeTransition(
              sizeFactor: widget.animation,
              axis: Axis.vertical,
              axisAlignment: -1.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: GestureDetector(
                  onTap: () {},
                  onVerticalDragUpdate: onDragClosing,
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.44),
                          spreadRadius: 0,
                          blurRadius: 17,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(29.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        left: 27.0,
                        right: 27.0,
                      ),
                      child: buildFormWidgets(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDragClosing(details) {
    if (details.delta.dy > 0) {
      widget.onClose(widget.animationController);
    }
  }

  Column buildFormWidgets() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'New folder',
          style: GoogleFonts.acme(fontSize: 30),
        ),
        const SizedBox(height: 23),
        FolderPreviewWidget(cubit: cubit),
        const SizedBox(
          height: 21,
        ),
        StylePickerWidget(cubit: cubit),
        const SizedBox(
          height: 21,
        ),
        TextFieldWidget(cubit: cubit),
        const SizedBox(
          height: 24,
        ),
        AppButtonWidget(
          icon: AppIcons.selected,
          text: 'Done',
          onPressed: () {
            widget.onDone(cubit.state.folder);
            widget.onClose(widget.animationController);
          },
          color: AppColors.darkBrown,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void _setStylePickerData() {
    for (var colorPicker in _colorPickers) {
      colorPicker.isActive = false;
      if (colorPicker.color == widget.folder.background) {
        colorPicker.isActive = true;
      }
    }
    for (var iconPicker in _iconPickers) {
      iconPicker.isActive = false;
      if (iconPicker.icon == widget.folder.icon.icon) {
        iconPicker.isActive = true;
      }
    }
  }
}
