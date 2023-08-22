import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_preview_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/style_picker_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/text_field_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/app_text_button.dart';

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
    color: AppColors.lightToggledGrey,
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
    with TickerProviderStateMixin {
  late FolderFormCubit cubit;
  late final Animation<double> animation;
  late double blurStatus;
  late final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Stack(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: blurStatus),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: value,
                  sigmaY: value,
                ),
                child: child,
              );
            },
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          FadeTransition(
            opacity: animation,
            child: Scaffold(
              backgroundColor: AppColors.transparent,
              body: Align(
                alignment: Alignment.bottomCenter,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  axisAlignment: -1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 35.0,
                      bottom: 30.0,
                      left: 10,
                      right: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          color: AppColors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(38.0),
                          ),
                        ),
                        child: buildFormWidgets(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );
    animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    );
    blurStatus = 18.0;
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        blurStatus = 18.0;
        setState(() {});
      } else if (status == AnimationStatus.reverse) {
        blurStatus = 0.0;
        setState(() {});
      }
    });
  }

  void onClose() {
    animationController.reverse().whenComplete(() => widget.onClose());
  }

  Widget buildFormWidgets() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 600),
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
              widget.folder.id == -1
                  ? LocaleKeys.folderFormTitle.tr()
                  : LocaleKeys.editFolderFormTitle.tr(),
              style: AppTextStyles.bigHeaderStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 27.0,
              right: 27.0,
            ),
            child: FolderPreviewWidget(cubit: cubit),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 21.0,
              left: 27.0,
              right: 27.0,
              bottom: 21.0,
            ),
            child: StylePickerWidget(cubit: cubit),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 27.0,
              right: 27.0,
              bottom: 24,
            ),
            child: TextFieldWidget(cubit: cubit),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppTextButtonWidget(
                text: LocaleKeys.cancel.tr(),
                onPressed: onClose,
                color: AppColors.darkGrey,
                activeColor: AppColors.carmineRed,
              ),
              AppTextButtonWidget(
                text: LocaleKeys.done.tr(),
                onPressed: () {
                  widget.onDone(cubit.state.folder);
                  onClose();
                },
                color: AppColors.darkGrey,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
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
