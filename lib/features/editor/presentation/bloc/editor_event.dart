import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/text_element.dart';
import '../../domain/entities/sticker_element.dart';
import '../../domain/entities/project.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object?> get props => [];
}

class EditorLoadProject extends EditorEvent {
  final String? projectId;
  const EditorLoadProject({this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class EditorAddText extends EditorEvent {
  final TextElement element;
  const EditorAddText(this.element);

  @override
  List<Object?> get props => [element];
}

class EditorUpdateText extends EditorEvent {
  final TextElement element;
  const EditorUpdateText(this.element);

  @override
  List<Object?> get props => [element];
}

class EditorRemoveText extends EditorEvent {
  final String elementId;
  const EditorRemoveText(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class EditorAddSticker extends EditorEvent {
  final StickerElement element;
  const EditorAddSticker(this.element);

  @override
  List<Object?> get props => [element];
}

class EditorUpdateSticker extends EditorEvent {
  final StickerElement element;
  const EditorUpdateSticker(this.element);

  @override
  List<Object?> get props => [element];
}

class EditorRemoveSticker extends EditorEvent {
  final String elementId;
  const EditorRemoveSticker(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class EditorDuplicateSticker extends EditorEvent {
  final String elementId;
  const EditorDuplicateSticker(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class EditorDuplicateText extends EditorEvent {
  final String elementId;
  const EditorDuplicateText(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class EditorSelectElement extends EditorEvent {
  final String? elementId;
  const EditorSelectElement(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class EditorSetBackground extends EditorEvent {
  final CanvasBackground type;
  final int? color;
  final String? imagePath;

  const EditorSetBackground({
    required this.type,
    this.color,
    this.imagePath,
  });

  @override
  List<Object?> get props => [type, color, imagePath];
}

class EditorUndo extends EditorEvent {
  const EditorUndo();
}

class EditorRedo extends EditorEvent {
  const EditorRedo();
}

class EditorSaveProject extends EditorEvent {
  const EditorSaveProject();
}

class EditorClearCanvas extends EditorEvent {
  const EditorClearCanvas();
}

class EditorMoveElement extends EditorEvent {
  final String elementId;
  final Offset position;
  const EditorMoveElement(this.elementId, this.position);

  @override
  List<Object?> get props => [elementId, position];
}

class EditorScaleElement extends EditorEvent {
  final String elementId;
  final double scale;
  const EditorScaleElement(this.elementId, this.scale);

  @override
  List<Object?> get props => [elementId, scale];
}

class EditorRotateElement extends EditorEvent {
  final String elementId;
  final double rotation;
  const EditorRotateElement(this.elementId, this.rotation);

  @override
  List<Object?> get props => [elementId, rotation];
}

class EditorSetExporting extends EditorEvent {
  final bool isExporting;
  final bool transparent;

  const EditorSetExporting(this.isExporting, {this.transparent = false});

  @override
  List<Object?> get props => [isExporting, transparent];
}
