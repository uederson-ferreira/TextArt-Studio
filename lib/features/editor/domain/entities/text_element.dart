import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum TextAlignment { left, center, right }

class TextElement extends Equatable {
  final String id;
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final Color? backgroundColor;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextAlignment alignment;
  final double rotation;
  final Offset position;
  final double scale;
  final double opacity;
  final bool hasShadow;
  final bool hasStroke;
  final Color strokeColor;
  final double strokeWidth;

  const TextElement({
    required this.id,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.backgroundColor,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.alignment = TextAlignment.center,
    this.rotation = 0,
    required this.position,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.hasShadow = false,
    this.hasStroke = false,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.0,
  });

  factory TextElement.create({
    String text = 'Toque para editar',
    String fontFamily = 'Inter',
    double fontSize = 32,
    Color color = Colors.white,
    Offset? position,
  }) {
    return TextElement(
      id: const Uuid().v4(),
      text: text,
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      position: position ?? const Offset(0, 0),
    );
  }

  TextElement copyWith({
    String? text,
    String? fontFamily,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextAlignment? alignment,
    double? rotation,
    Offset? position,
    double? scale,
    double? opacity,
    bool? hasShadow,
    bool? hasStroke,
    Color? strokeColor,
    double? strokeWidth,
  }) {
    return TextElement(
      id: id,
      text: text ?? this.text,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      alignment: alignment ?? this.alignment,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      hasShadow: hasShadow ?? this.hasShadow,
      hasStroke: hasStroke ?? this.hasStroke,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'fontFamily': fontFamily,
        'fontSize': fontSize,
        'color': color.toARGB32(),
        'backgroundColor': backgroundColor?.toARGB32(),
        'fontWeight': fontWeight.value,
        'fontStyle': fontStyle.index,
        'alignment': alignment.index,
        'rotation': rotation,
        'positionX': position.dx,
        'positionY': position.dy,
        'scale': scale,
        'opacity': opacity,
        'hasShadow': hasShadow,
        'hasStroke': hasStroke,
        'strokeColor': strokeColor.toARGB32(),
        'strokeWidth': strokeWidth,
      };

  factory TextElement.fromJson(Map<String, dynamic> json) => TextElement(
        id: json['id'] as String,
        text: json['text'] as String,
        fontFamily: json['fontFamily'] as String,
        fontSize: (json['fontSize'] as num).toDouble(),
        color: Color(json['color'] as int),
        backgroundColor: json['backgroundColor'] != null
            ? Color(json['backgroundColor'] as int)
            : null,
        fontWeight: _fontWeightFromValue(json['fontWeight'] as int),
        fontStyle: FontStyle.values[json['fontStyle'] as int],
        alignment: TextAlignment.values[json['alignment'] as int],
        rotation: (json['rotation'] as num).toDouble(),
        position: Offset(
          (json['positionX'] as num).toDouble(),
          (json['positionY'] as num).toDouble(),
        ),
        scale: (json['scale'] as num).toDouble(),
        opacity: (json['opacity'] as num).toDouble(),
        hasShadow: json['hasShadow'] as bool,
        hasStroke: json['hasStroke'] as bool,
        strokeColor: Color(json['strokeColor'] as int),
        strokeWidth: (json['strokeWidth'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [
        id,
        text,
        fontFamily,
        fontSize,
        color,
        backgroundColor,
        fontWeight,
        fontStyle,
        alignment,
        rotation,
        position,
        scale,
        opacity,
        hasShadow,
        hasStroke,
        strokeColor,
        strokeWidth,
      ];
}

FontWeight _fontWeightFromValue(int value) {
  return FontWeight.values.firstWhere(
    (w) => w.value == value,
    orElse: () => FontWeight.normal,
  );
}
