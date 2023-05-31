import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Claims Test', (WidgetTester tester) async {
    // Start app ..
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'damke23@gmail.com');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'Jabuka32!');
    await tester.pumpAndSettle();

    // Scroll until LOGIN is visible
    await tester.dragUntilVisible(
      find.text('LOGIN'),
      find.byKey(const ValueKey('Container')),
      const Offset(-250, 0),
    );

    // Tap Login button
    await tester.tap(find.byKey(const ValueKey('loginbutton')));
    await tester.pumpAndSettle();

    // Wait for the dialog box to appear
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Transactions is pressed
    final transactionHistory = find.byIcon(Icons.history);
    await tester.tap(transactionHistory);
    await tester.pumpAndSettle(const Duration(seconds: 6));

    // First transaction selected
    final firstTransaction = find.byType(ListTile).first;
    await tester.tap(firstTransaction);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Transaction Details'), findsWidgets);

    // Claim button tapped
    final claimbutton = find.text('Claim');
    await tester.tap(claimbutton);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Create Claim'), findsWidgets);

    // Create new claim
    await tester.enterText(
        find.byKey(const ValueKey('subjectField')), 'Ovo je novi claim');
    await tester.enterText(find.byKey(const ValueKey('descriptionField')),
        'Ovo je opis novog claima');
    final submitclaimbutton = find.text('Submit Claim');
    await tester.tap(submitclaimbutton);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Claim created succesfully'), findsWidgets);

    /*
    // Upload new file
    final uploadfilebutton = find.text('Upload File');
    await tester.tap(uploadfilebutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final allowbutton = find.text('Allow');
    await tester.tap(allowbutton);
    final file = new File('integration_test_resources/test.png');
    */

    // Back pressed
    var backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Details'), findsWidgets);

    // Back pressed again
    backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Claim button for transactions pressed
    final claimButton = find.byIcon(Icons.warning_sharp);
    await tester.tap(claimButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('My Claims'), findsWidgets);

    // Last claim selected
    final lastClaim = find.byType(ListTile).last;
    await tester.tap(lastClaim);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Claim Details'), findsWidgets);

    // Write message
    await tester.enterText(
        find.byKey(const ValueKey('messageField')), 'Upomoc !!');

    // Send message
    final sendButton = find.byKey(const ValueKey('sendMessage'));
    await tester.tap(sendButton);
    expect(find.text('Upomoc !!'), findsWidgets);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Back pressed
    backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('My Claims'), findsWidgets);

    // Back pressed again
    backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);
  });
}
