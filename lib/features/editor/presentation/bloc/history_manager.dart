import '../../domain/entities/project.dart';
import '../../../../core/constants/app_constants.dart';

/// Gerencia pilhas de undo/redo para o editor.
/// Mantém no máximo [AppConstants.maxHistory] estados.
class HistoryManager {
  final List<Project> _undoStack = [];
  final List<Project> _redoStack = [];

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// Registra um novo estado (limpa redo stack)
  void push(Project state) {
    _undoStack.add(state);
    if (_undoStack.length > AppConstants.maxHistory) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  /// Desfaz: retorna o estado anterior, empurra current para redo
  Project? undo(Project current) {
    if (_undoStack.isEmpty) return null;
    _redoStack.add(current);
    return _undoStack.removeLast();
  }

  /// Refaz: retorna o próximo estado, empurra current para undo
  Project? redo(Project current) {
    if (_redoStack.isEmpty) return null;
    _undoStack.add(current);
    return _redoStack.removeLast();
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
