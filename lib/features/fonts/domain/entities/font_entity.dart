import 'package:equatable/equatable.dart';

enum FontCategory {
  all,
  sansSerif,
  serif,
  handwriting,
  display,
  monospace,
}

class FontEntity extends Equatable {
  final String family;
  final FontCategory category;
  final bool isPremium;
  final bool isCached;
  final String? previewUrl;

  const FontEntity({
    required this.family,
    required this.category,
    this.isPremium = false,
    this.isCached = false,
    this.previewUrl,
  });

  FontEntity copyWith({
    String? family,
    FontCategory? category,
    bool? isPremium,
    bool? isCached,
    String? previewUrl,
  }) {
    return FontEntity(
      family: family ?? this.family,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      isCached: isCached ?? this.isCached,
      previewUrl: previewUrl ?? this.previewUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'family': family,
        'category': category.index,
        'isPremium': isPremium,
        'isCached': isCached,
        'previewUrl': previewUrl,
      };

  factory FontEntity.fromJson(Map<String, dynamic> json) => FontEntity(
        family: json['family'] as String,
        category: FontCategory.values[json['category'] as int],
        isPremium: json['isPremium'] as bool? ?? false,
        isCached: json['isCached'] as bool? ?? false,
        previewUrl: json['previewUrl'] as String?,
      );

  @override
  List<Object?> get props =>
      [family, category, isPremium, isCached, previewUrl];
}
