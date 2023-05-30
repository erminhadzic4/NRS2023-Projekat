import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nrs2023/auth_provider.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:nrs2023/screens/loginAuth.dart';

void main() {
  group('LoginAuthScreenState', () {
    late LoginAuthScreenState loginAuthScreenState;

    setUp(() {
      loginAuthScreenState = LoginAuthScreenState();
      loginAuthScreenState.initState();
    });

    test('Initial email and phone code values are set', () {
      expect(loginAuthScreenState.emailCode, '123456');
      expect(loginAuthScreenState.phoneCode, '654321');
    });

    test('getEmailCode returns the correct value', () {
      final emailCode = loginAuthScreenState.getEmailCode();
      expect(emailCode, '123456');
    });

    test('getPhoneCode returns the correct value', () {
      final phoneCode = loginAuthScreenState.getPhoneCode();
      expect(phoneCode, '654321');
    });

    test('Provjera getEmailCode i getPhoneCode metoda', () {
      final loginAuthScreen = LoginAuthScreenState();

      // Postavlja vrijednosti za emailCode i phoneCode
      loginAuthScreen.emailCode = 'ABC123';
      loginAuthScreen.phoneCode = 'XYZ789';

      // Provjerava da li se getEmailCode metoda vraća ispravnu vrijednost
      expect(loginAuthScreen.getEmailCode(), 'ABC123');

      // Provjerava da li se getPhoneCode metoda vraća ispravnu vrijednost
      expect(loginAuthScreen.getPhoneCode(), 'XYZ789');
    });

    testWidgets('Entering email code updates emailCode', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginAuthScreen()));

      final emailField = find.widgetWithText(TextField, 'Enter code sent to email');
      await tester.enterText(emailField, '789012');

      expect(find.text('789012'), findsOneWidget);
    });

    testWidgets('Entering phone code updates phoneCode', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginAuthScreen()));

      final phoneField = find.widgetWithText(TextField, 'Enter code sent to phone');
      await tester.enterText(phoneField, '210987');

      expect(find.text('210987'), findsOneWidget);
    });

  });
}





