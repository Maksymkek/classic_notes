import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_screen_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/note_form_screen.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_screen_widget.dart';

class AppNavigation {
  final initialRoute = FolderScreen.screenName;

  final routes = <String, Widget Function(BuildContext)>{
    FolderScreen.screenName: (context) => const FolderScreen()
  };

  Route<Object> onGenerateRoot(RouteSettings settings) {
    switch (settings.name) {
      case NotesScreenWidget.screenName:
        final folder = settings.arguments as Folder;
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return NotesScreenWidget(folder: folder);
          },
        );
      case NoteFormScreenWidget.screenName:
        List<dynamic> arguments = settings.arguments as List<dynamic>;
        final note = arguments[0] as Note;
        final notePageCubit = arguments[1] as NotePageCubit;
        return MaterialPageRoute(builder: (context) {
          return NoteFormScreenWidget(
            note: note,
            notePageCubit: notePageCubit,
          );
        });
      default:
        const defaultWidget = Text('Navigation error :(');
        return MaterialPageRoute(builder: (context) => defaultWidget);
    }
  }
}
