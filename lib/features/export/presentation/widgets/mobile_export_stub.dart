import 'dart:typed_data';

Future<bool> requestPhotoPermission() async => true;

Future<void> shareImage(Uint8List bytes) async {
  throw UnsupportedError('Share not supported on this platform');
}

Future<void> saveToGallery(Uint8List bytes) async {
  throw UnsupportedError('Gallery not supported on this platform');
}
