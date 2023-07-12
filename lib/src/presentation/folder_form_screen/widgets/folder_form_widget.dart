import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_preview_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/style_picker_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/text_field_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/app_text_button.dart';

const Duration duration = Duration(milliseconds: 200);

final List<ColorPickerModel> _colorPickers = [
  ColorPickerModel(
    color: AppColors.darkBrown,
    iconColor: AppColors.seashellWhite,
    isActive: true,
  ),
  ColorPickerModel(
    color: AppColors.sapphireBlue,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.khaki,
    iconColor: AppColors.darkBrown,
  ),
  ColorPickerModel(
    color: AppColors.darkGreen,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.darkPurple,
    iconColor: AppColors.seashellWhite,
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
    color: AppColors.seashellWhite,
    iconColor: AppColors.darkBrown,
  ),
  ColorPickerModel(
    color: AppColors.carmineRed,
    iconColor: AppColors.seashellWhite,
  ),
  ColorPickerModel(
    color: AppColors.lightBlue,
    iconColor: AppColors.darkGrey,
  )
];
final List<IconPickerModel> _iconPickers = [
  IconPickerModel(icon: AppIcons.folder, iconSize: 20, trueIconSize: 28),
  IconPickerModel(icon: AppIcons.music, iconSize: 22, trueIconSize: 34),
  IconPickerModel(icon: AppIcons.medicine, iconSize: 18, trueIconSize: 24),
  IconPickerModel(icon: AppIcons.selected, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.media, iconSize: 18, trueIconSize: 28),
  IconPickerModel(icon: AppIcons.book, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.time, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.newNote, iconSize: 22, trueIconSize: 32),
  IconPickerModel(icon: AppIcons.lock, iconSize: 22, trueIconSize: 32)
];

final BoxShadow shadow = BoxShadow(
  color: AppColors.black.withOpacity(0.23),
  spreadRadius: 0,
  blurRadius: 5,
  offset: const Offset(0, 0), // changes position of shadow
);

class FolderFormWidget extends StatefulWidget {
  const FolderFormWidget({
    super.key,
    required this.onClose,
    required this.folder,
    required this.onDone,
  });

  final void Function() onClose;

  final Folder folder;
  final Function(Folder) onDone;

  @override
  State<FolderFormWidget> createState() => _FolderFormWidgetState();
}

class _FolderFormWidgetState extends State<FolderFormWidget>
    with SingleTickerProviderStateMixin {
  late FolderFormCubit cubit;
  late final Animation<double> animation;
  late final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: FadeTransition(
        opacity: animation,
        child: Scaffold(
          backgroundColor: AppColors.black.withOpacity(0.05),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizeTransition(
              sizeFactor: animation,
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
                          color: AppColors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(38.0),
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

  @override
  void initState() {
    super.initState();
    _setStylePickerData();
    cubit = FolderFormCubit(
      FolderFormState(
        folder: Folder(
          id: widget.folder.id,
          icon: widget.folder.icon,
          title: widget.folder.title,
          background: widget.folder.background,
          dateOfLastChange: widget.folder.dateOfLastChange,
        ),
        colorPickers: _colorPickers,
        iconPickers: _iconPickers,
      ),
    );
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
  }

  void onClose() {
    animationController.reverse().whenComplete(() => widget.onClose());
  }

  void onDragClosing(details) {
    if (details.delta.dy > 0) {
      onClose();
    }
  }

  Column buildFormWidgets() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'New folder',
          style: GoogleFonts.alexandria(
            fontSize: 34,
            color: AppColors.darkBrown,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
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
        AppTextButtonWidget(
          icon: AppIcons.selected,
          text: 'Done',
          onPressed: () {
            widget.onDone(cubit.state.folder);
            onClose();
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
