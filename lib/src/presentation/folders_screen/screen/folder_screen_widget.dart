import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_button.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_state.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_actions_widget.dart';
import 'package:notes/src/presentation/mixins/screen_need_redraw.dart';
import 'package:notes/src/presentation/notes_app.dart';
import 'package:notes/src/presentation/reusable_widgets/appbar/appbar.dart';
import 'package:notes/src/presentation/reusable_widgets/appbar/appbar_list_data.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/item_screen/item_list_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/progress_indicator/circle_progress_indicator.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  static const screenName = 'folder_screen';

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen>
    with RouteAware, ScreenRedraw {
  late final FolderPageCubit cubit;
  late final Future<void> future;
  late List<DropDownItem> dropDownItems;
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
              return BuildAppBar(dropdownItems: cubit.dropDownItems ?? []);
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
                  return (needRedraw<Folder>(current, prev));
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      AppBarListData(
                        title: '${cubit.state.items.length} folders',
                      ),

                      //FolderListWidget(cubit: cubit)
                      buildFolderListWidget()
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

  ItemListWidget<Folder, FolderPageState, FolderPageCubit>
      buildFolderListWidget() =>
          ItemListWidget<Folder, FolderPageState, FolderPageCubit>(
            cubit: cubit,
            actionsWidget: FolderActionsWidget.new,
          );

  @override
  void didPop() {
    super.didPop();
    DropDownOverlayManager.dispose();
    FolderFormOverlayManager.dispose();
  }

  @override
  void initState() {
    super.initState();
    cubit = DI.getInstance().folderPageCubit;
    future = cubit.onScreenLoad();
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
