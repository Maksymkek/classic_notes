import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';

class FolderFormState {
  FolderFormState({
    required this.folder,
    required this.colorPickers,
    required this.iconPickers,
  });

  final Folder folder;
  final List<ColorPickerModel> colorPickers;
  final List<IconPickerModel> iconPickers;
}
