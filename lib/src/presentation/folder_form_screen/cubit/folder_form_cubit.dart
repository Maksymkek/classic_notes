import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';

class FolderFormCubit extends Cubit<FolderFormState> {
  FolderFormCubit(
    super.state,
  );

  void _copyWith({
    List<ColorPickerModel>? colorPickers,
    List<IconPickerModel>? iconPickers,
    Folder? folder,
  }) {
    emit(
      FolderFormState(
        folder: folder ?? state.folder,
        colorPickers: colorPickers ?? state.colorPickers,
        iconPickers: iconPickers ?? state.iconPickers,
      ),
    );
  }

  void onColorSelected(ColorPickerModel selectedColorPicker) {
    final newColorPickers = state.colorPickers.map((colorPicker) {
      if (colorPicker != selectedColorPicker) {
        colorPicker.isActive = false;
        return colorPicker;
      } else {
        selectedColorPicker.isActive = true;
        return selectedColorPicker;
      }
    }).toList();
    state.folder.background = selectedColorPicker.color;
    state.folder.icon = Icon(
      state.folder.icon.icon,
      size: state.folder.icon.size,
      color: selectedColorPicker.iconColor,
    );
    _copyWith(colorPickers: newColorPickers);
  }

  void onIconSelected(IconPickerModel selectedIconPicker) {
    final newIconPickers = state.iconPickers.map((iconPicker) {
      if (iconPicker != selectedIconPicker) {
        iconPicker.isActive = false;
        return iconPicker;
      } else {
        selectedIconPicker.isActive = true;
        return selectedIconPicker;
      }
    }).toList();
    state.folder.icon = Icon(
      selectedIconPicker.icon,
      size: selectedIconPicker.trueIconSize,
      color: state.folder.icon.color,
    );
    _copyWith(iconPickers: newIconPickers);
  }

  void onTextEntered(String text) {
    Folder folder = state.folder;
    folder.name = text;
    _copyWith(folder: folder);
  }
}
