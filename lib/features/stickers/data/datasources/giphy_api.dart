import 'package:dio/dio.dart';

class GiphyResult {
  final String id;
  final String title;
  final String previewUrl;  // smaller, for grid preview
  final String originalUrl; // full quality, for canvas

  const GiphyResult({
    required this.id,
    required this.title,
    required this.previewUrl,
    required this.originalUrl,
  });

  factory GiphyResult.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final small = images['fixed_height_small'] as Map<String, dynamic>? ?? {};
    final fixed = images['fixed_height'] as Map<String, dynamic>? ?? {};
    final original = images['original'] as Map<String, dynamic>? ?? {};

    return GiphyResult(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      previewUrl: (small['url'] ?? fixed['url'] ?? original['url'] ?? '') as String,
      originalUrl: (fixed['url'] ?? original['url'] ?? '') as String,
    );
  }
}

class GiphyApi {
  static const _apiKey = 'rbAnQSMT4J5OGut7NrpqchRVLaa57EAb';
  static const _base = 'https://api.giphy.com/v1';

  final Dio _dio;

  GiphyApi()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

  /// Busca GIFs por termo. [stickersOnly] usa o endpoint de stickers (fundo transparente).
  Future<List<GiphyResult>> search(
    String query, {
    int offset = 0,
    int limit = 30,
    bool stickersOnly = false,
  }) async {
    final type = stickersOnly ? 'stickers' : 'gifs';
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_base/$type/search',
        queryParameters: {
          'api_key': _apiKey,
          'q': query.trim(),
          'limit': limit,
          'offset': offset,
          'rating': 'g',
          'lang': 'pt',
        },
      );
      final data = response.data?['data'];
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(GiphyResult.fromJson)
          .where((r) => r.previewUrl.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Retorna GIFs em alta (sem termo de busca).
  Future<List<GiphyResult>> trending({
    int offset = 0,
    int limit = 30,
    bool stickersOnly = false,
  }) async {
    final type = stickersOnly ? 'stickers' : 'gifs';
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_base/$type/trending',
        queryParameters: {
          'api_key': _apiKey,
          'limit': limit,
          'offset': offset,
          'rating': 'g',
        },
      );
      final data = response.data?['data'];
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(GiphyResult.fromJson)
          .where((r) => r.previewUrl.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
