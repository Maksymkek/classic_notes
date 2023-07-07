/// needed to check whether buffer can redo or undo
class BufferStatus {
  BufferStatus({this.canRedo = false, this.canUndo = false});

  final bool canRedo;
  final bool canUndo;

  BufferStatus copyWith({bool? canRedo, bool? canUndo}) {
    return BufferStatus(
        canRedo: canRedo ?? this.canRedo, canUndo: canUndo ?? this.canUndo);
  }
}
