import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';

class FolderScreenState extends ScreenState<Folder> {
  FolderScreenState({
    required ItemSettingsModel settings,
    required Map<int, Folder> folders,
  }) : super(folders, settings);
}
