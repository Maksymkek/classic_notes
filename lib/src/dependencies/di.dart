import 'package:flutter/material.dart';
import 'package:notes/src/data/repository/folder_repository_impl.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';
import 'package:notes/src/domain/use_case/folder_case/add_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/delete_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/get_folders_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folders_order_interactor.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';

class DI {
  DI._();

  static DI? _instance;

  late FolderRepository folderRepository;
  late GetFoldersInteractor _getFoldersInteractor;
  late AddFolderInteractor _addFolderInteractor;
  late UpdateFolderInteractor _updateFolderInteractor;
  late DeleteFolderInteractor _deleteFolderInteractor;
  late UpdateFoldersOrderInteractor _updateFoldersOrderInteractor;
  late FolderPageCubit folderPageCubit;
  late FolderFormCubit folderFormCubit;
  final List<ColorPickerModel> _colorPickers = [
    ColorPickerModel(
      color: AppColors.sapphireBlue,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.lightYellow,
      iconColor: AppColors.darkBrown,
      isActive: true,
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
    ColorPickerModel(color: Colors.red, iconColor: AppColors.seashellWhite)
  ];
  final List<IconPickerModel> _iconPickers = [
    IconPickerModel(
        icon: AppIcons.folder, iconSize: 20, isActive: true, trueIconSize: 28),
    IconPickerModel(icon: AppIcons.music, iconSize: 22, trueIconSize: 34),
    IconPickerModel(icon: AppIcons.medicine, iconSize: 18, trueIconSize: 24),
    IconPickerModel(icon: AppIcons.selected, iconSize: 22, trueIconSize: 32),
    IconPickerModel(icon: AppIcons.media, iconSize: 22, trueIconSize: 32),
    IconPickerModel(icon: AppIcons.book, iconSize: 22, trueIconSize: 32),
    IconPickerModel(icon: AppIcons.time, iconSize: 22, trueIconSize: 32)
  ];

  static DI getInstance() {
    return _instance ?? (_instance = DI._());
  }

  Future<void> init() async {
    folderRepository = MockFolderRepository();
    _getFoldersInteractor = GetFoldersInteractor(folderRepository);
    _addFolderInteractor = AddFolderInteractor(folderRepository);
    _updateFolderInteractor = UpdateFolderInteractor(folderRepository);
    _deleteFolderInteractor = DeleteFolderInteractor(folderRepository);
    _updateFoldersOrderInteractor =
        UpdateFoldersOrderInteractor(folderRepository);
    folderPageCubit = FolderPageCubit(
      _getFoldersInteractor,
      _addFolderInteractor,
      _updateFolderInteractor,
      _deleteFolderInteractor,
      _updateFoldersOrderInteractor,
    );
    folderFormCubit = FolderFormCubit(
      FolderFormState(
        folder: Folder(
          id: -1,
          name: 'Quick Notes',
          background: AppColors.lightYellow,
          icon: const Icon(AppIcons.folder, size: 28),
          dateOfCreation: DateTime.now(),
        ),
        colorPickers: _colorPickers,
        iconPickers: _iconPickers,
      ),
    );
  }
}
