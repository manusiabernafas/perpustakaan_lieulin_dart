import 'package:flutter_test/flutter_test.dart';
import 'package:t4_form/main.dart';

void main() {
  testWidgets('PerpustakaanApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PerpustakaanApp());
    expect(find.byType(PerpustakaanApp), findsOneWidget);
  });
}
