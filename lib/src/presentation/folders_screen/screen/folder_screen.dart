import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/appbar.dart';
import 'package:notes/src/presentation/common_widgets/appbar_list_data.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_button.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_state.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = DI.getInstance().folderPageCubit;
    future = cubit.onScreenLoad();
    dropDownItems = [
      DropDownItem(
        title: 'Sort by',
        icon: Icons.sort_rounded,
        actions: [
          DropdownAction(
            title: 'date',
            onTap: () {},
            isSelected: true,
            icon: Icons.date_range_rounded,
          ),
          DropdownAction(
            title: 'name',
            onTap: () {},
            isSelected: false,
            icon: Icons.abc,
          ),
        ],
      ),
      DropDownItem(
        title: 'Sort order',
        icon: Icons.swap_vert_rounded,
        actions: [
          DropdownAction(
            title: 'descending',
            onTap: () {},
            isSelected: true,
            icon: Icons.arrow_downward_rounded,
          ),
          DropdownAction(
            title: 'ascending',
            onTap: () {},
            isSelected: false,
            icon: Icons.arrow_upward_rounded,
          ),
        ],
      ),
      DropDownItem(
        title: 'Change theme',
        icon: Icons.brightness_4,
        actions: [
          DropdownAction(
            title: 'light',
            onTap: () {},
            isSelected: true,
            icon: Icons.light_mode_rounded,
          ),
          DropdownAction(
            title: 'dark',
            onTap: () {},
            isSelected: false,
            icon: Icons.dark_mode_rounded,
          ),
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderPageCubit, FolderPageState>(
      bloc: cubit,
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: AppColors.milkWhite,
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      AppBarListData(
                        title: '${state.folderWidgets.length} folders',
                      ),
                      const SizedBox(height: 5),
                      _buildFolderList(state, cubit),
                    ],
                  );
                } else {
                  return const CircleProgressIndicatorWidget();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Expanded _buildFolderList(FolderPageState state, FolderPageCubit cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
        child: DragAndDropLists(
          onItemReorder: (
            int oldItemIndex,
            int oldListIndex,
            int newItemIndex,
            int newListIndex,
          ) {
            cubit.onItemDragged(oldItemIndex, newItemIndex);
          },
          onListReorder: (int oldListIndex, int newListIndex) {},
          children: [
            DragAndDropList(
              children: state.folderWidgets
                  .map((folderWidget) => DragAndDropItem(child: folderWidget))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
