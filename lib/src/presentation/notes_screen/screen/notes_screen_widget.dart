import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/common_widgets/appbar.dart';
import 'package:notes/src/presentation/common_widgets/appbar_list_data.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/note_form_screen/screen/note_form_screen.dart';
import 'package:notes/src/presentation/notes_app.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_state.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_list_widget.dart';

class NotesScreenWidget extends StatefulWidget {
  const NotesScreenWidget({super.key, required this.folder});

  static const screenName = 'notes_screen';

  final Folder folder;

  @override
  State<NotesScreenWidget> createState() => _NotesScreenWidgetState();
}

class _NotesScreenWidgetState extends State<NotesScreenWidget> with RouteAware {
  late final List<DropDownItem> dropDownItems;
  late final NotePageCubit cubit;
  late final Future<void> screenLoad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 7.0, bottom: 5.0),
        child: AppIconButtonWidget(
          iconSize: 36,
          color: AppColors.darkBrown,
          activeColor: AppColors.lightBrown,
          icon: AppIcons.newNote,
          onPressed: () {
            Navigator.of(context).pushNamed(
              NoteFormScreenWidget.screenName,
              arguments: Note(
                id: -1,
                text: '',
                name: '',
                dateOfLastChange: DateTime.now(),
              ),
            );
          },
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: FutureBuilder(
          future: screenLoad,
          builder: (context, snapshot) {
            if (ConnectionState.done == snapshot.connectionState) {
              return BuildAppBar(
                dropdownItems: dropDownItems,
              );
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
          future: screenLoad,
          builder: (context, snapshot) {
            if (ConnectionState.done == snapshot.connectionState) {
              return BlocBuilder<NotePageCubit, NotePageState>(
                bloc: cubit,
                buildWhen: (prev, current) {
                  if (current.notes.length != prev.notes.length ||
                      current.sortOrder != prev.sortOrder ||
                      current.sortBy != prev.sortBy) {
                    return true;
                  }
                  return false;
                },
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      const SizedBox(height: 5),
                      AppBarListData(
                        title: '${cubit.state.notes.length} notes',
                        folder: widget.folder,
                      ),
                      const SizedBox(height: 10),
                      NoteListWidget(cubit: cubit),
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
    cubit = NotePageCubit(widget.folder);
    screenLoad = cubit.onScreenLoad();
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
  void dispose() {
    super.dispose();
    NotesApp.routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotesApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPop() {
    super.didPop();
    DropDownOverlayManager.dispose();
  }
}
