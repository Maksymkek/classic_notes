import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';

class FolderPageState extends ScreenState<Folder> {
  FolderPageState({
    required ItemSettingsModel settings,
    required Map<int, Folder> folders,
  }) : super(folders, settings);
}
