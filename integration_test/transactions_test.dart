import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test', (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('EmailField')), 'damke23@gmail.com');
    await tester.enterText(find.byKey(const ValueKey('PasswordField')), 'Jabuka32!');
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('LOGIN'),
      find.byKey(const ValueKey('Container')),
      const Offset(-250, 0),
    );
    await tester.tap(find.byKey(const ValueKey('loginbutton')));
    await tester.pumpAndSettle();

    // Wait for the dialog box to appear
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}