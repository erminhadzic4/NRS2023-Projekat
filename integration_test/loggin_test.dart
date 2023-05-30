import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets('Login Failed Test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'afrljak1@etf.unsa.ba');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'AminaFrljak311!'); //inncorect password
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
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

  });

  testWidgets('Login Test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'afrljak1@etf.unsa.ba');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'AminaFrljak31!');
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
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));
  });


  testWidgets('Logout Test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'afrljak1@etf.unsa.ba');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'AminaFrljak31!');
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
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

    // Find the logout button and tap it.
    final logout = find.byIcon(Icons.logout);
    await tester.tap(logout);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Verify that we are on the WelcomeScreen after logout.
    //  final welcomeScreen = find.byKey(ValueKey('welcome_screen'));
    //expect(welcomeScreen, findsOneWidget);
    await Future.delayed(const Duration(seconds: 5));
    expect(find.text('Home Screen'), findsWidgets);
  });



  testWidgets('Register Page UI Test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Verify the presence of input fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Re-enter Password'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Account Number'), findsOneWidget);
  });



  testWidgets('Account Creation Test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('EmailField')), 'amina.frljak3p@gmail.com');
    await tester.enterText(
        find.byKey(const ValueKey('PasswordField')), 'AminaAmina1!');
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
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));


    final account = find.byIcon(Icons.account_box);
    await tester.tap(account);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('Account Creation'), findsWidgets);

  /*  expect(find.text('Currency'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Inforamtion');
    await tester.enterText(find.byType(TextFormField).last, 'Description');

    final submitButton = find.text('SUBMIT').first;
    await tester.tap(submitButton);

    //assert that no transaction with amount of 20 is found
    await tester.pumpAndSettle(const Duration(seconds: 6));
    await Future.delayed(const Duration(seconds: 3));*/

    //expect(find.byKey(Key('SubmitButton')), findsOneWidget);
    //expect(find.byKey(Key('UploadButton')), findsOneWidget);


    //Select Currency
    /* final currencyDropdown = find.byKey(const ValueKey('selectCurrencyDropdown'));
    await tester.tap(currencyDropdown);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final USD = find.text("USD").last;
    await tester.tap(USD);
    await tester.pumpAndSettle(const Duration(seconds: 3));


    await tester.enterText(find.byKey(const ValueKey('accountinformation')), 'Account information');
    await tester.enterText(find.byKey(const ValueKey('description')), 'Description');*/
  });

}



/*
 testWidgets('Register New User Test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Press login button
    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Enter email and password
    await tester.enterText(
        find.byKey(const ValueKey('Email')), 'afrljak1@etf.unsa.ba');
    await tester.enterText(
        find.byKey(const ValueKey('Name')), 'Amina');
    await tester.enterText(
        find.byKey(const ValueKey('Last Name')), 'Frljak');
    await tester.enterText(
        find.byKey(const ValueKey('Usernam')), 'Amina1');
    await tester.enterText(
        find.byKey(const ValueKey('Password')), 'AminaAmina1!');
    await tester.enterText(
        find.byKey(const ValueKey('Re-enter Password')), 'AminaAmina1!');
    await tester.enterText(
        find.byKey(const ValueKey('Address')),'Adresa');
    await tester.enterText(
        find.byKey(const ValueKey('Account Number')), '1');

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
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 10));
  });


 */