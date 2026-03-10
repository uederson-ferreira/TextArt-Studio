import 'dart:io';

void main() {
  final pubCache = Platform.environment['PUB_CACHE'] ?? '${Platform.environment['HOME']}/.pub-cache';
  final dir = Directory('$pubCache/hosted/pub.dev');
  final gfDir = dir.listSync().firstWhere(
    (e) => e.path.contains('google_fonts-'),
    orElse: () => Directory('.'),
  );
  
  if (gfDir.path == '.') return;
  
  final partsFile = File('${gfDir.path}/lib/google_fonts.dart');
  final content = partsFile.readAsStringSync();
  
  final regex = RegExp(r'static TextStyle ([a-zA-Z0-9_]+)\(');
  final matches = regex.allMatches(content);
  final families = <String>{};
  
  for (final match in matches) {
    if (match.groupCount >= 1) {
      final name = match.group(1)!;
      if (name != 'getFont') {
         // Convert camelCase to human readable via regex
         final withSpaces = name.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
         final formatted = (withSpaces[0].toUpperCase() + withSpaces.substring(1)).replaceAll('_', ' ');
         families.add(formatted);
      }
    }
  }
  
  final out = File('lib/features/fonts/data/repositories/all_google_fonts.dart');
  final buffer = StringBuffer();
  buffer.writeln('import \'../../domain/entities/font_entity.dart\';');
  buffer.writeln('\nconst List<FontEntity> allGoogleFonts = [');
  
  for (final f in families.toList()..sort()) {
    final safeName = f.replaceAll("'", "\\'");
    buffer.writeln('  FontEntity(family: \'$safeName\', category: FontCategory.sansSerif),');
  }
  
  buffer.writeln('];');
  out.writeAsStringSync(buffer.toString());
  print('Generated ${families.length} fonts.');
}
