import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
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
    final newSelColorPicker = ColorPickerModel.from(selectedColorPicker);
    final newColorPickers = state.colorPickers.map((colorPicker) {
      if (colorPicker != selectedColorPicker) {
        final newColorPicker = ColorPickerModel.from(colorPicker);
        newColorPicker.isActive = false;
        return newColorPicker;
      } else {
        newSelColorPicker.isActive = true;
        return newSelColorPicker;
      }
    }).toList();
    state.folder.background = newSelColorPicker.color;
    state.folder.icon = Icon(
      state.folder.icon.icon,
      size: state.folder.icon.size,
      color: newSelColorPicker.iconColor,
    );
    _copyWith(colorPickers: newColorPickers);
  }

  void onIconSelected(IconPickerModel selectedIconPicker) {
    final newSelIconPicker = IconPickerModel.from(selectedIconPicker);
    final newIconPickers = state.iconPickers.map((iconPicker) {
      if (iconPicker != selectedIconPicker) {
        var newIconPicker = IconPickerModel.from(iconPicker);
        newIconPicker.isActive = false;
        return newIconPicker;
      } else {
        newSelIconPicker.isActive = true;
        return newSelIconPicker;
      }
    }).toList();
    state.folder.icon = Icon(
      newSelIconPicker.icon,
      size: newSelIconPicker.trueIconSize,
      color: state.folder.icon.color,
    );
    _copyWith(iconPickers: newIconPickers);
  }

  void onTextEntered(String text) {
    Folder folder = state.folder;
    _copyWith(folder: folder.copyWith(title: text));
  }
}
