import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';
import 'package:notes/src/presentation/common_widgets/appbar.dart';
import 'package:notes/src/presentation/common_widgets/appbar_list_data.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_button.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_state.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_list_widget.dart';
import 'package:notes/src/presentation/notes_app.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  static const screenName = 'folder_screen';

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> with RouteAware {
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
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BuildAppBar(dropdownItems: dropDownItems);
            } else {
              return Container();
            }
          },
        ),
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
                  return (needRedraw(current, prev));
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
  void didPop() {
    super.didPop();
    DropDownOverlayManager.dispose();
    FolderFormOverlayManager.dispose();
  }

  bool needRedraw(FolderPageState current, FolderPageState prev) {
    bool needToRedraw = current.folders.length != prev.folders.length ||
        current.sortOrder != prev.sortOrder ||
        current.sortBy != prev.sortBy;
    if (needToRedraw) {
      return true;
    }
    for (int i = 0; i < current.folders.length; i += 1) {
      if (current.folders[i]?.dateOfLastChange !=
          prev.folders[i]?.dateOfLastChange) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    cubit = DI.getInstance().folderPageCubit;
    future = cubit.onScreenLoad();
    dropDownItems = [
      DropDownItem(
        title: 'Sort by',
        icon: CupertinoIcons.list_dash,
        iconSize: 14.5,
        actions: [
          DropDownAction(
            title: SortBy.date.name,
            onTap: () => cubit.onSortByChanged(SortBy.date.name),
            isSelected: cubit.state.sortBy == SortBy.date.name,
            icon: CupertinoIcons.calendar,
          ),
          DropDownAction(
            title: SortBy.name.name,
            onTap: () => cubit.onSortByChanged(SortBy.name.name),
            isSelected: cubit.state.sortBy == SortBy.name.name,
            icon: CupertinoIcons.textformat,
          ),
          DropDownAction(
            title: SortBy.custom.name,
            onTap: () => cubit.onSortByChanged(SortBy.custom.name),
            isSelected: cubit.state.sortBy == SortBy.custom.name,
            icon: CupertinoIcons.pencil,
          ),
        ],
      ),
      DropDownItem(
        title: 'Sort order',
        icon: CupertinoIcons.arrow_up_arrow_down,
        iconSize: 13,
        actions: [
          DropDownAction(
            title: SortOrder.descending.name,
            onTap: () => cubit.onSortOrderChanged(SortOrder.descending.name),
            isSelected: cubit.state.sortOrder == SortOrder.descending.name,
            icon: CupertinoIcons.arrow_down,
            iconSize: 13,
          ),
          DropDownAction(
            title: SortOrder.ascending.name,
            onTap: () => cubit.onSortOrderChanged(SortOrder.ascending.name),
            isSelected: cubit.state.sortOrder == SortOrder.ascending.name,
            icon: CupertinoIcons.arrow_up,
            iconSize: 13,
          ),
        ],
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotesApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    NotesApp.routeObserver.unsubscribe(this);
  }
}
