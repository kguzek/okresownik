import 'package:flutter_test/flutter_test.dart';

import 'package:okresownik/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const OkresownikApp());
    expect(find.byType(OkresownikApp), findsOneWidget);
  });
}
