import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_text_controller.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/rich_undo_model.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// custom [UndoHistoryController] for [NoteTextController].
class RichUndoController {
  RichUndoController(this._controller, this._cubit) {
    _buffer.add(
      RichUndoModel(
        List.from(_controller.deltas),
        _controller.text,
      ),
    );
    _cubit.copyWith(
      bufferStatus:
          _cubit.state.bufferStatus.copyWith(canRedo: false, canUndo: false),
    );
  }

  final RichTextEditorController _controller;

  final NoteFormCubit _cubit;

  ///stores buffered data in [RichUndoModel]
  final List<RichUndoModel> _buffer = [];

  /// maximum length of [_buffer]
  static const int _maxBufferValue = 100000;

  /// amount of words in [SaveMode.strongCompact]
  static const int _compactDensity = 3;

  /// declares how many words will be before [SaveMode.strongCompact]
  static const int _strongCompactDelay = 15;

  /// current index in [_buffer]
  int _bufferIterator = 0;

  ///to determine from which buffer index do [SaveMode.compact]
  int _baseCompactIterator = 0;

  ///to determine from which buffer index do [SaveMode.strongCompact]
  int _strongCompactIterator = 1;

  ///to determine the start of gluing in [_compact]
  final RegExp _tabulation = RegExp(r'[\s.,!?;:]');

  get baseCompactIterator => _baseCompactIterator;

  List<RichUndoModel> get buffer => List.from(_buffer);

  int get bufferIterator => _bufferIterator;

  /// needed to call when needed to bufferize data.
  ///
  /// Parameters:
  ///
  /// [lastChar] - last deleted/added character
  ///
  /// [deltas] - deltas to store
  ///
  /// [text] - text to store
  Future<void> updateBuffer(
    String lastChar,
    List<TextDelta> deltas,
    String text,
  ) async {
    await Future<void>(() {
      if (_buffer.length > _maxBufferValue) {
        _buffer.removeAt(0);
      }
      _buffer.add(RichUndoModel(List.from(deltas), text));
      if (_needToCompact(lastChar)) {
        _compact();
      }
      _bufferIterator = _buffer.length - 1;
      if (!_cubit.state.bufferStatus.canUndo) {
        _checkBufferStatus();
      }
      if (_cubit.state.bufferStatus.canRedo) {
        _cubit.copyWith(
          bufferStatus: _cubit.state.bufferStatus.copyWith(canRedo: false),
        );
      }
    });
  }

  void _checkBufferStatus() {
    if (_bufferIterator >= _buffer.length - 1) {
      _cubit.copyWith(
        bufferStatus:
            _cubit.state.bufferStatus.copyWith(canRedo: false, canUndo: true),
      );
    } else if (_bufferIterator <= 0) {
      _cubit.copyWith(
        bufferStatus:
            _cubit.state.bufferStatus.copyWith(canRedo: true, canUndo: false),
      );
    } else if (_buffer.isEmpty) {
      _cubit.copyWith(
        bufferStatus:
            _cubit.state.bufferStatus.copyWith(canRedo: false, canUndo: false),
      );
    } else {
      _cubit.copyWith(
        bufferStatus:
            _cubit.state.bufferStatus.copyWith(canRedo: true, canUndo: true),
      );
    }
  }

  /// move to newer changes
  Future<RichUndoModel?> redo() {
    return Future<RichUndoModel?>(() {
      _bufferIterator += 1;
      _checkBufferStatus();
      if (_bufferIterator < _buffer.length) {
        return _buffer[_bufferIterator];
      }
      _bufferIterator -= 1;
      return null;
    });
  }

  /// revert to previous change
  Future<RichUndoModel?> undo() {
    return Future<RichUndoModel?>(() {
      _bufferIterator -= 1;
      _checkBufferStatus();
      if (_bufferIterator >= 0) {
        return _buffer[_bufferIterator];
      }
      _bufferIterator += 1;
      return null;
    });
  }

  void _compact() {
    var start = _baseCompactIterator + _strongCompactIterator;
    _buffer.removeRange(
      start,
      _buffer.length - 1,
    );
    if (_needStrongCompact()) {
      _buffer.removeRange(
        _strongCompactIterator,
        _strongCompactIterator + _compactDensity,
      );

      _strongCompactIterator += 1;
      _baseCompactIterator -= _compactDensity;
    } else {
      _baseCompactIterator += 1;
    }
    _bufferIterator = _buffer.length - 1;
  }

  bool _needStrongCompact() {
    return (_baseCompactIterator + 1) % _compactDensity == 0 &&
        _baseCompactIterator >= _strongCompactDelay;
  }

  bool _needToCompact(String lastChar) {
    if (_tabulation.hasMatch(lastChar)) {
      return true;
    } else {
      return false;
    }
  }
}
