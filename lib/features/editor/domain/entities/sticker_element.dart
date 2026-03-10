import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum StickerType { svg, emoji, lottie, image }

class StickerElement extends Equatable {
  final String id;
  final String assetPath;
  final StickerType type;
  final Offset position;
  final double size;
  final double rotation;
  final double scale;
  final double opacity;

  const StickerElement({
    required this.id,
    required this.assetPath,
    required this.type,
    required this.position,
    this.size = 80,
    this.rotation = 0,
    this.scale = 1.0,
    this.opacity = 1.0,
  });

  factory StickerElement.create({
    required String assetPath,
    StickerType type = StickerType.svg,
    Offset? position,
    double size = 80,
  }) {
    return StickerElement(
      id: const Uuid().v4(),
      assetPath: assetPath,
      type: type,
      position: position ?? const Offset(0, 0),
      size: size,
    );
  }

  StickerElement copyWith({
    String? id,
    String? assetPath,
    StickerType? type,
    Offset? position,
    double? size,
    double? rotation,
    double? scale,
    double? opacity,
  }) {
    return StickerElement(
      id: id ?? this.id,
      assetPath: assetPath ?? this.assetPath,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'assetPath': assetPath,
        'type': type.index,
        'positionX': position.dx,
        'positionY': position.dy,
        'size': size,
        'rotation': rotation,
        'scale': scale,
        'opacity': opacity,
      };

  factory StickerElement.fromJson(Map<String, dynamic> json) => StickerElement(
        id: json['id'] as String,
        assetPath: json['assetPath'] as String,
        type: StickerType.values[json['type'] as int],
        position: Offset(
          (json['positionX'] as num).toDouble(),
          (json['positionY'] as num).toDouble(),
        ),
        size: (json['size'] as num).toDouble(),
        rotation: (json['rotation'] as num).toDouble(),
        scale: (json['scale'] as num).toDouble(),
        opacity: (json['opacity'] as num).toDouble(),
      );

  @override
  List<Object?> get props =>
      [id, assetPath, type, position, size, rotation, scale, opacity];
}
