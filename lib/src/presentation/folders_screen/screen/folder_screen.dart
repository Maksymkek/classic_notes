import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/app_settings.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/appbar.dart';
import 'package:notes/src/presentation/common_widgets/appbar_list_data.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_button.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_state.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_list_widget.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  static const screenName = 'folder_screen';

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  late final FolderPageCubit cubit;
  late final Future<void> future;
  late final List<DropDownItem> dropDownItems;
  late final AppSettings appSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: const FolderFormButtonWidget(),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: BuildAppBar(dropdownItems: dropDownItems),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BlocBuilder<FolderPageCubit, FolderPageState>(
                bloc: cubit,
                buildWhen: (prev, current) {
                  if (current.folders.length != prev.folders.length ||
                      current.sortOrder != prev.sortOrder ||
                      current.sortBy != prev.sortBy) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      AppBarListData(
                        title: '${cubit.state.folders.length} folders',
                      ),
                      const SizedBox(height: 10),
                      FolderListWidget(cubit: cubit)
                    ],
                  );
                },
              );
            } else {
              return const CircleProgressIndicatorWidget();
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = DI.getInstance().folderPageCubit;
    appSettings = DI.getInstance().appSettingsRepository.getSettings();
    future = cubit.onScreenLoad();
    dropDownItems = [
      DropDownItem(
        title: 'Sort by',
        icon: Icons.sort_rounded,
        actions: [
          DropDownAction(
            title: SortBy.date.name,
            onTap: () => cubit.onSortByChanged(SortBy.date.name),
            isSelected: cubit.state.sortBy == SortBy.date.name,
            icon: Icons.date_range_rounded,
          ),
          DropDownAction(
            title: SortBy.name.name,
            onTap: () => cubit.onSortByChanged(SortBy.name.name),
            isSelected: cubit.state.sortBy == SortBy.name.name,
            icon: Icons.abc,
          ),
          DropDownAction(
            title: SortBy.custom.name,
            onTap: () => cubit.onSortByChanged(SortBy.custom.name),
            isSelected: cubit.state.sortBy == SortBy.custom.name,
            icon: Icons.edit_outlined,
          ),
        ],
      ),
      DropDownItem(
        title: 'Sort order',
        icon: Icons.swap_vert_rounded,
        actions: [
          DropDownAction(
            title: SortOrder.descending.name,
            onTap: () => cubit.onSortOrderChanged(SortOrder.descending.name),
            isSelected: cubit.state.sortOrder == SortOrder.descending.name,
            icon: Icons.arrow_downward_rounded,
          ),
          DropDownAction(
            title: SortOrder.ascending.name,
            onTap: () => cubit.onSortOrderChanged(SortOrder.ascending.name),
            isSelected: cubit.state.sortOrder == SortOrder.ascending.name,
            icon: Icons.arrow_upward_rounded,
          ),
        ],
      ),
    ];
  }
}
