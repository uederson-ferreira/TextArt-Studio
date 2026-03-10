import 'dart:io';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<bool> requestPhotoPermission() async {
  final status = await Permission.photos.request();
  return status.isGranted || status.isLimited;
}

Future<void> shareImage(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File(
      '${dir.path}/textart_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes);
  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'image/png')],
    text: 'Criado com TextArt Studio',
  );
}

Future<void> saveToGallery(Uint8List bytes) async {
  // Save as PNG file to preserve transparency (saveImage() converts to JPEG)
  final dir = await getTemporaryDirectory();
  final path =
      '${dir.path}/textart_${DateTime.now().millisecondsSinceEpoch}.png';
  await File(path).writeAsBytes(bytes);

  final result = await ImageGallerySaver.saveFile(path);
  final bool success = result['isSuccess'] ?? false;
  if (!success) {
    throw 'Plugin falhou: ${result['errorMessage'] ?? 'Causa desconhecida'}';
  }
}
