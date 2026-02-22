import 'package:flutter_test/flutter_test.dart';

import 'package:xocobaby13/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Sign in'), findsOneWidget);
  });
}
