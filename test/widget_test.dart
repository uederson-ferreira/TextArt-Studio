import 'package:flutter_test/flutter_test.dart';

import 'package:textart_studio/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TextArtStudioApp());
    await tester.pumpAndSettle();

    expect(find.text('TextArt Studio'), findsWidgets);
  });
}
