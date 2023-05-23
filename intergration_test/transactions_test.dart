import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nrs2023/main.dart' as app;

/*void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('hello',(WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          //final Finder button = find.widgetWithText(ElevatedButton, 'Register');

          //tester.tap(button);


        });
  });
}

 */
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Press log in button', (WidgetTester tester) async {
    // Run the app
    app.main();
    await tester.pumpAndSettle();

    // Find the log in button by its key
    final logInButton = find.byKey(const ValueKey('logInButton'));

    // Tap the log in button
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify that the LogIn screen is pushed
    //expect(find.byType(MaterialApp), findsOneWidget);
    //expect(1, 1);
  });
}
