import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../core/constants/app_constants.dart';

/// Captures a [RepaintBoundary] and returns PNG bytes.
/// Adds watermark text for free users.
class ExportToImage {
  final bool isPremium;

  const ExportToImage({this.isPremium = false});

  Future<Uint8List?> call({
    required GlobalKey repaintKey,
    double? pixelRatio,
  }) async {
    final ratio = pixelRatio ??
        (isPremium
            ? AppConstants.exportPixelRatioPremium
            : AppConstants.exportPixelRatioFree);

    try {
      final boundary = repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: ratio);

      if (!isPremium) {
        // Add watermark using picture recorder
        final watermarked = await _addWatermark(image);
        final byteData =
            await watermarked.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }

      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<ui.Image> _addWatermark(ui.Image source) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // Draw original image
    canvas.drawImage(source, Offset.zero, ui.Paint());

    // Draw watermark text
    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 20,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
          color: const ui.Color(0x99FFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      )
      ..addText('TextArt Studio');

    final paragraph = paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(width: source.width.toDouble()),
      );

    canvas.drawParagraph(
      paragraph,
      Offset(0, source.height - 40),
    );

    final picture = recorder.endRecording();
    return picture.toImage(source.width, source.height);
  }
}
