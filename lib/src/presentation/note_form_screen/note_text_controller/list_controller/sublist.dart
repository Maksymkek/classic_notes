import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/base_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';

class SubList implements ListInput {
  @override
  List<String> getSeparator(String text, int baseOffset) {
    return ['\u2002', '\u2022', '\u2002'];
  }

  @override
  ListStatus get listStatus => ListStatus.sublist;
}
