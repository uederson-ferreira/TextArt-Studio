import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/project.dart';
import '../../../projects/domain/repositories/project_repository.dart';
import 'editor_event.dart';
import 'editor_state.dart';
import 'history_manager.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final HistoryManager _history = HistoryManager();
  final ProjectRepository _projectRepository;

  EditorBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(EditorState.initial()) {
    on<EditorLoadProject>(_onLoadProject);
    on<EditorAddText>(_onAddText);
    on<EditorUpdateText>(_onUpdateText);
    on<EditorRemoveText>(_onRemoveText);
    on<EditorAddSticker>(_onAddSticker);
    on<EditorUpdateSticker>(_onUpdateSticker);
    on<EditorRemoveSticker>(_onRemoveSticker);
    on<EditorDuplicateSticker>(_onDuplicateSticker);
    on<EditorDuplicateText>(_onDuplicateText);
    on<EditorSelectElement>(_onSelectElement);
    on<EditorSetBackground>(_onSetBackground);
    on<EditorUndo>(_onUndo);
    on<EditorRedo>(_onRedo);
    on<EditorSaveProject>(_onSaveProject);
    on<EditorClearCanvas>(_onClearCanvas);
    on<EditorMoveElement>(_onMoveElement);
    on<EditorScaleElement>(_onScaleElement);
    on<EditorRotateElement>(_onRotateElement);
    on<EditorSetExporting>(_onSetExporting);
  }

  Future<void> _onLoadProject(
      EditorLoadProject event, Emitter<EditorState> emit) async {
    emit(state.copyWith(status: EditorStatus.loading));
    _history.clear();

    if (event.projectId != null) {
      final project = await _projectRepository.loadProject(event.projectId!);
      emit(state.copyWith(
        status: EditorStatus.ready,
        project: project ?? Project.create(),
      ));
    } else {
      emit(state.copyWith(
        status: EditorStatus.ready,
        project: Project.create(),
      ));
    }
  }

  void _onAddText(EditorAddText event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final newProject = state.project.copyWith(
      textElements: [...state.project.textElements, event.element],
    );
    emit(state.copyWith(
      project: newProject,
      selectedElementId: event.element.id,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onUpdateText(EditorUpdateText event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final updated = state.project.textElements.map((e) {
      return e.id == event.element.id ? event.element : e;
    }).toList();
    emit(state.copyWith(
      project: state.project.copyWith(textElements: updated),
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onRemoveText(EditorRemoveText event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final filtered = state.project.textElements
        .where((e) => e.id != event.elementId)
        .toList();
    emit(state.copyWith(
      project: state.project.copyWith(textElements: filtered),
      clearSelection: true,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onAddSticker(EditorAddSticker event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final newProject = state.project.copyWith(
      stickerElements: [...state.project.stickerElements, event.element],
    );
    emit(state.copyWith(
      project: newProject,
      selectedElementId: event.element.id,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onUpdateSticker(
      EditorUpdateSticker event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final updated = state.project.stickerElements.map((e) {
      return e.id == event.element.id ? event.element : e;
    }).toList();
    emit(state.copyWith(
      project: state.project.copyWith(stickerElements: updated),
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onRemoveSticker(
      EditorRemoveSticker event, Emitter<EditorState> emit) {
    _history.push(state.project);
    final filtered = state.project.stickerElements
        .where((e) => e.id != event.elementId)
        .toList();
    emit(state.copyWith(
      project: state.project.copyWith(stickerElements: filtered),
      clearSelection: true,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onDuplicateSticker(
      EditorDuplicateSticker event, Emitter<EditorState> emit) {
    final original = state.project.stickerElements
        .where((e) => e.id == event.elementId)
        .firstOrNull;
    if (original == null) return;
    _history.push(state.project);
    const offset = Offset(24, 24);
    final copy = original.copyWith(
      id: const Uuid().v4(),
      position: original.position + offset,
    );
    emit(state.copyWith(
      project: state.project.copyWith(
          stickerElements: [...state.project.stickerElements, copy]),
      selectedElementId: copy.id,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onDuplicateText(
      EditorDuplicateText event, Emitter<EditorState> emit) {
    final original = state.project.textElements
        .where((e) => e.id == event.elementId)
        .firstOrNull;
    if (original == null) return;
    _history.push(state.project);
    const offset = Offset(24, 24);
    final copy = original.copyWith(
      id: const Uuid().v4(),
      position: original.position + offset,
    );
    emit(state.copyWith(
      project: state.project.copyWith(
          textElements: [...state.project.textElements, copy]),
      selectedElementId: copy.id,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onSelectElement(
      EditorSelectElement event, Emitter<EditorState> emit) {
    emit(state.copyWith(
      selectedElementId: event.elementId,
      clearSelection: event.elementId == null,
    ));
  }

  void _onSetBackground(
      EditorSetBackground event, Emitter<EditorState> emit) {
    _history.push(state.project);
    emit(state.copyWith(
      project: state.project.copyWith(
        backgroundType: event.type,
        backgroundColor: event.color,
        backgroundImagePath: event.imagePath,
      ),
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onUndo(EditorUndo event, Emitter<EditorState> emit) {
    final prev = _history.undo(state.project);
    if (prev != null) {
      emit(state.copyWith(
        project: prev,
        clearSelection: true,
        canUndo: _history.canUndo,
        canRedo: _history.canRedo,
      ));
    }
  }

  void _onRedo(EditorRedo event, Emitter<EditorState> emit) {
    final next = _history.redo(state.project);
    if (next != null) {
      emit(state.copyWith(
        project: next,
        clearSelection: true,
        canUndo: _history.canUndo,
        canRedo: _history.canRedo,
      ));
    }
  }

  Future<void> _onSaveProject(
      EditorSaveProject event, Emitter<EditorState> emit) async {
    emit(state.copyWith(status: EditorStatus.saving));
    try {
      await _projectRepository.saveProject(state.project);
      emit(state.copyWith(status: EditorStatus.ready));
    } catch (_) {
      emit(state.copyWith(status: EditorStatus.ready));
    }
  }

  void _onClearCanvas(EditorClearCanvas event, Emitter<EditorState> emit) {
    _history.push(state.project);
    emit(state.copyWith(
      project: state.project.copyWith(
        textElements: [],
        stickerElements: [],
      ),
      clearSelection: true,
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    ));
  }

  void _onMoveElement(EditorMoveElement event, Emitter<EditorState> emit) {
    final textIdx = state.project.textElements
        .indexWhere((e) => e.id == event.elementId);
    if (textIdx >= 0) {
      final updated = [...state.project.textElements];
      updated[textIdx] = updated[textIdx].copyWith(position: event.position);
      emit(state.copyWith(
        project: state.project.copyWith(textElements: updated),
      ));
      return;
    }
    final stickerIdx = state.project.stickerElements
        .indexWhere((e) => e.id == event.elementId);
    if (stickerIdx >= 0) {
      final updated = [...state.project.stickerElements];
      updated[stickerIdx] =
          updated[stickerIdx].copyWith(position: event.position);
      emit(state.copyWith(
        project: state.project.copyWith(stickerElements: updated),
      ));
    }
  }

  void _onScaleElement(EditorScaleElement event, Emitter<EditorState> emit) {
    final textIdx = state.project.textElements
        .indexWhere((e) => e.id == event.elementId);
    if (textIdx >= 0) {
      final updated = [...state.project.textElements];
      updated[textIdx] = updated[textIdx].copyWith(scale: event.scale);
      emit(state.copyWith(
        project: state.project.copyWith(textElements: updated),
      ));
      return;
    }
    final stickerIdx = state.project.stickerElements
        .indexWhere((e) => e.id == event.elementId);
    if (stickerIdx >= 0) {
      final updated = [...state.project.stickerElements];
      updated[stickerIdx] = updated[stickerIdx].copyWith(scale: event.scale);
      emit(state.copyWith(
        project: state.project.copyWith(stickerElements: updated),
      ));
    }
  }

  void _onRotateElement(
      EditorRotateElement event, Emitter<EditorState> emit) {
    final textIdx = state.project.textElements
        .indexWhere((e) => e.id == event.elementId);
    if (textIdx >= 0) {
      final updated = [...state.project.textElements];
      updated[textIdx] =
          updated[textIdx].copyWith(rotation: event.rotation);
      emit(state.copyWith(
        project: state.project.copyWith(textElements: updated),
      ));
      return;
    }
    final stickerIdx = state.project.stickerElements
        .indexWhere((e) => e.id == event.elementId);
    if (stickerIdx >= 0) {
      final updated = [...state.project.stickerElements];
      updated[stickerIdx] =
          updated[stickerIdx].copyWith(rotation: event.rotation);
      emit(state.copyWith(
        project: state.project.copyWith(stickerElements: updated),
      ));
    }
  }

  void _onSetExporting(EditorSetExporting event, Emitter<EditorState> emit) {
    emit(state.copyWith(
      isExporting: event.isExporting,
      exportTransparent: event.transparent,
      clearSelection: event.isExporting, // Hide handles during export
    ));
  }
}
