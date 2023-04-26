//TODO how to store image
class Note {
  Note({
    required this.id,
    required this.text,
    required this.name,
    required this.dateOfLastChange,
  });

  final int id;
  String name;
  String text;
  DateTime dateOfLastChange;
}
