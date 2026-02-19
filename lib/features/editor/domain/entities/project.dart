import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'text_element.dart';
import 'sticker_element.dart';

enum CanvasBackground { color, image, transparent }

class Project extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TextElement> textElements;
  final List<StickerElement> stickerElements;
  final CanvasBackground backgroundType;
  final int backgroundColor;
  final String? backgroundImagePath;
  final double canvasWidth;
  final double canvasHeight;
  final String? thumbnailPath;

  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.textElements = const [],
    this.stickerElements = const [],
    this.backgroundType = CanvasBackground.color,
    this.backgroundColor = 0xFF000000,
    this.backgroundImagePath,
    this.canvasWidth = 1080,
    this.canvasHeight = 1080,
    this.thumbnailPath,
  });

  factory Project.create({String? name}) {
    final now = DateTime.now();
    return Project(
      id: const Uuid().v4(),
      name: name ?? 'Projeto ${now.day}/${now.month}',
      createdAt: now,
      updatedAt: now,
    );
  }

  Project copyWith({
    String? name,
    DateTime? updatedAt,
    List<TextElement>? textElements,
    List<StickerElement>? stickerElements,
    CanvasBackground? backgroundType,
    int? backgroundColor,
    String? backgroundImagePath,
    double? canvasWidth,
    double? canvasHeight,
    String? thumbnailPath,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      textElements: textElements ?? this.textElements,
      stickerElements: stickerElements ?? this.stickerElements,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'textElements': textElements.map((e) => e.toJson()).toList(),
        'stickerElements': stickerElements.map((e) => e.toJson()).toList(),
        'backgroundType': backgroundType.index,
        'backgroundColor': backgroundColor,
        'backgroundImagePath': backgroundImagePath,
        'canvasWidth': canvasWidth,
        'canvasHeight': canvasHeight,
        'thumbnailPath': thumbnailPath,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        textElements: (json['textElements'] as List<dynamic>)
            .map((e) => TextElement.fromJson(e as Map<String, dynamic>))
            .toList(),
        stickerElements: (json['stickerElements'] as List<dynamic>)
            .map((e) => StickerElement.fromJson(e as Map<String, dynamic>))
            .toList(),
        backgroundType:
            CanvasBackground.values[json['backgroundType'] as int],
        backgroundColor: json['backgroundColor'] as int,
        backgroundImagePath: json['backgroundImagePath'] as String?,
        canvasWidth: (json['canvasWidth'] as num).toDouble(),
        canvasHeight: (json['canvasHeight'] as num).toDouble(),
        thumbnailPath: json['thumbnailPath'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
        updatedAt,
        textElements,
        stickerElements,
        backgroundType,
        backgroundColor,
        backgroundImagePath,
        canvasWidth,
        canvasHeight,
        thumbnailPath,
      ];
}
