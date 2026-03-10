import 'package:dio/dio.dart';

/// Result item from the Iconify search API.
class SvgRepoResult {
  /// Full icon name like "mdi:heart" or "ph:star"
  final String fullName;

  /// Human-readable title derived from the name
  final String title;

  const SvgRepoResult({required this.fullName, required this.title});

  /// URL to download the raw SVG content
  String get downloadUrl {
    final parts = fullName.split(':');
    if (parts.length != 2) return '';
    return 'https://api.iconify.design/${parts[0]}/${parts[1]}.svg?color=%23ffffff';
  }

  factory SvgRepoResult.fromFullName(String fullName) {
    final namePart = fullName.contains(':') ? fullName.split(':').last : fullName;
    final title = namePart.replaceAll('-', ' ').replaceAll('_', ' ');
    return SvgRepoResult(fullName: fullName, title: _capitalize(title));
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// Thin client for the Iconify API (https://iconify.design).
/// Free, no API key, 200 000+ icons, CORS-open.
class SvgRepoApi {
  static const _base = 'https://api.iconify.design';

  final Dio _dio;

  SvgRepoApi()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

  /// Searches icons and returns up to [limit] results starting at [start].
  Future<List<SvgRepoResult>> search(
    String query, {
    int start = 0,
    int limit = 40,
  }) async {
    if (query.trim().isEmpty) return [];
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_base/search',
        queryParameters: {
          'query': query.trim(),
          'limit': limit,
          'start': start,
        },
      );
      final icons = response.data?['icons'];
      if (icons is! List) return [];
      return icons
          .whereType<String>()
          .map(SvgRepoResult.fromFullName)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Downloads the raw SVG XML string for a result.
  /// The icon is rendered in white so it can be coloured via ShaderMask on canvas.
  Future<String?> downloadSvg(SvgRepoResult result) async {
    final url = result.downloadUrl;
    if (url.isEmpty) return null;
    try {
      final response = await _dio.get<String>(url);
      final content = response.data;
      if (content == null || !content.contains('<svg')) return null;
      // Normalise: ensure viewBox exists and size is responsive
      return content
          .replaceAll('width="1em"', 'width="100%"')
          .replaceAll('height="1em"', 'height="100%"');
    } catch (_) {
      return null;
    }
  }
}
