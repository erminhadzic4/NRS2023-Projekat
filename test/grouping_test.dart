/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:nrs2023/auth_provider.dart';
import 'package:nrs2023/screens/donation.dart';
import 'package:nrs2023/screens/grouping.dart';
import 'package:nrs2023/screens/logIn.dart';
import 'package:provider/provider.dart';

void main() {

  testWidgets('Grouping Test', (WidgetTester tester) async {
    // Start app
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(), // Provide an instance of AuthProvider
          ),
        ],
        child: MaterialApp(
          home: logIn(),
        ),
      ),
    );

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
/*
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

    // Grouping is pressed
    var grouping = find.byIcon(Icons.group_sharp);
    await tester.tap(grouping);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Group by'), findsWidgets);

    // Currency is selected
    final currencyButton = find.text('Currency');
    await tester.tap(currencyButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Grouping'), findsWidgets);

    // Back pressed
    var backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

    // Grouping is pressed
    grouping = find.byIcon(Icons.group_sharp);
    await tester.tap(grouping);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Group by'), findsWidgets);

    // Transaction Type is selected
    final typeButton = find.text('Transaction Type');
    await tester.tap(typeButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Grouping'), findsWidgets);

    // Back pressed
    backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Transactions'), findsWidgets);

 */
  });
}
*/