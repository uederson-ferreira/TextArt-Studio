import 'package:equatable/equatable.dart';
import '../../domain/entities/text_element.dart';
import '../../domain/entities/sticker_element.dart';
import '../../domain/entities/project.dart';

enum EditorStatus { initial, loading, ready, saving, error }

class EditorState extends Equatable {
  final EditorStatus status;
  final Project project;
  final String? selectedElementId;
  final bool canUndo;
  final bool canRedo;
  final String? errorMessage;

  const EditorState({
    this.status = EditorStatus.initial,
    required this.project,
    this.selectedElementId,
    this.canUndo = false,
    this.canRedo = false,
    this.errorMessage,
  });

  factory EditorState.initial() => EditorState(
        project: Project.create(),
      );

  List<TextElement> get textElements => project.textElements;
  List<StickerElement> get stickerElements => project.stickerElements;

  EditorState copyWith({
    EditorStatus? status,
    Project? project,
    String? selectedElementId,
    bool clearSelection = false,
    bool? canUndo,
    bool? canRedo,
    String? errorMessage,
  }) {
    return EditorState(
      status: status ?? this.status,
      project: project ?? this.project,
      selectedElementId:
          clearSelection ? null : selectedElementId ?? this.selectedElementId,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        project,
        selectedElementId,
        canUndo,
        canRedo,
        errorMessage,
      ];
}
