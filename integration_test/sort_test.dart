import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/cupertino.dart';

import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Sort Test', (WidgetTester tester) async {
    // Start app
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

    // Wait for the dialog box to appear
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));

    // Transactions is pressed
    final transactionHistory = find.byIcon(Icons.history);
    await tester.tap(transactionHistory);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Sort is pressed
    var sortbutton = find.byIcon(Icons.sort);
    await tester.tap(sortbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Sort by'), findsWidgets);

    // Ascending amount is pressed
    final ascendingbutton = find.text('Amount (ascending)');
    await tester.tap(ascendingbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Sort is pressed
    sortbutton = find.byIcon(Icons.sort);
    await tester.tap(sortbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Sort by'), findsWidgets);

    // Descending amount is pressed
    final descendingbutton = find.text('Amount (descending)');
    await tester.tap(descendingbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Sort is pressed
    sortbutton = find.byIcon(Icons.sort);
    await tester.tap(sortbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Sort by'), findsWidgets);

    // Descending date is pressed
    final descendingbuttondate = find.text('Date (descending)');
    await tester.tap(descendingbuttondate);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Sort is pressed
    sortbutton = find.byIcon(Icons.sort);
    await tester.tap(sortbutton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Sort by'), findsWidgets);

    // Ascending date is pressed
    final ascendingbuttondate = find.text('Date (ascending)');
    await tester.tap(ascendingbuttondate);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);
  });
}
