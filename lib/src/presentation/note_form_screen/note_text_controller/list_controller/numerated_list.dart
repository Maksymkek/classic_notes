import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/base_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';

class NumList implements ListInput {
  int _currentLine = 0;

  get currentLine => _currentLine;
  //нужен вызов если что-то было изменено в тексте

  void updateLine(String text, int baseOffset) {
    var prevLineIndex =
        text.substring(0, baseOffset).lastIndexOf(RegExp(r'\n\d+\)\u2002'));
    if (prevLineIndex == -1) {
      _currentLine = 0;
    } else {
      int prevLine = int.parse(
        text.substring(
          prevLineIndex + 1,
          text.substring(prevLineIndex).indexOf(')') + prevLineIndex,
        ),
      );
      _currentLine = prevLine;
    }
  }

  @override
  List<String> getSeparator(String text, int baseOffset) {
    updateLine(text, baseOffset);
    _currentLine += 1;
    return [_currentLine.toString(), ')', '\u2002'];
  }

  @override
  ListStatus get listStatus => ListStatus.enumerated;
}
