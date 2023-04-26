import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/note.dart';

class NoteFormCubit extends Cubit<Note> {
  NoteFormCubit(super.initialState);

  void onTitleSetted(String title) {}
}
