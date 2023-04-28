import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';

abstract class ListInput {
  final ListStatus listStatus;

  ListInput(this.listStatus);
  List<String> getSeparator(String text, int baseOffset);
}
