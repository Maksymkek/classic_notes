class Note {
  Note({
    required this.id,
    required this.text,
    required this.title,
    required this.dateOfLastChange,
    this.controllerMap,
  });

  final int id;
  String title;
  String text;
  DateTime dateOfLastChange;
  Map<String, dynamic>? controllerMap;

  Note copyWith({
    String? title,
    String? text,
    DateTime? dateOfLastChange,
    Map<String, dynamic>? controllerMap,
  }) {
    return Note(
      id: id,
      text: text ?? this.text,
      title: title ?? this.title,
      dateOfLastChange: dateOfLastChange ?? this.dateOfLastChange,
      controllerMap: controllerMap ?? this.controllerMap,
    );
  }
}
