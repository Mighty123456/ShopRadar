import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopRadarApp());
    expect(find.byType(ShopRadarApp), findsOneWidget);
  });
}
