import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test', (WidgetTester tester) async {
    // Run the app
    app.main();
    await tester.pumpAndSettle();

    // Find the log in button by its key
    final logInButton = find.byKey(const ValueKey('logInButton'));

    // Tap the log in button
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Enter valid credentials in the username and password fields.
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'damke23@gmail.com');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'Jabuka32!');

    // Scroll down until LOGIN button is visible
    await tester.dragUntilVisible(
      find.text('LOGIN'),
      find.byKey(const ValueKey('Container')),
      const Offset(-250, 0),
    );
    await Future.delayed(const Duration(seconds: 1));
    // Tap the login button.
    await tester.tap(find.byKey(const ValueKey('loginbutton')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 8));
    // Tap OK
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  });
}
