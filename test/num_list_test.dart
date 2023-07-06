import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/numerated_list.dart';
import 'package:test/test.dart';

void main() {
  test('Counter should be incremented', () {
    final numlist = NumList();
    numlist.updateLine('Hello\n2)\u2002I am the best', 15);
    expect(numlist.currentLine, 2);
  });
}
