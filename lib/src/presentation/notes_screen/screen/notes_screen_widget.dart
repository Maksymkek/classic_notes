import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/mixins/screen_need_redraw.dart';
import 'package:notes/src/presentation/note_form_screen/screen/note_form_screen.dart';
import 'package:notes/src/presentation/notes_app.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_state.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_widget_actions.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/reusable_widgets/appbar/appbar.dart';
import 'package:notes/src/presentation/reusable_widgets/appbar/appbar_list_data.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/item_screen/item_list_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/progress_indicator/circle_progress_indicator.dart';

class NotesScreenWidget extends StatefulWidget {
  const NotesScreenWidget({super.key, required this.folder});

  static const screenName = 'notes_screen';

  final Folder folder;

  @override
  State<NotesScreenWidget> createState() => _NotesScreenWidgetState();
}

class _NotesScreenWidgetState extends State<NotesScreenWidget>
    with RouteAware, ScreenRedraw {
  late List<DropDownItem> dropDownItems;
  late final NotePageCubit cubit;
  late final Future<void> screenLoad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 7.0, bottom: 5.0),
        child: AppIconButtonWidget(
          iconSize: 42,
          color: AppColors.darkBrown,
          activeColor: AppColors.lightBrown,
          icon: AppIcons.newNote,
          onPressed: () {
            Navigator.of(context).pushNamed(
              NoteFormScreenWidget.screenName,
              arguments: <dynamic>[
                Note(
                  id: -1,
                  title: '',
                  text: '',
                  dateOfLastChange: DateTime.now(),
                ),
                cubit
              ],
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
                dropdownItems: cubit.dropDownItems ?? [],
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
                  return needRedraw<Note>(current, prev);
                },
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      const SizedBox(height: 5),
                      AppBarListData(
                        title: '${cubit.state.items.length} notes',
                        folder: widget.folder,
                      ),
                      ItemListWidget<Note, NotePageState, NotePageCubit>(
                        cubit: cubit,
                        actionsWidget: NoteActionsWidget.new,
                      ),
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
