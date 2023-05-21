// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nrs2023/main.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:nrs2023/screens/logIn.dart';
import 'package:nrs2023/screens/register.dart';

void main() {
 testWidgets('Test provjere valjanosti unosa', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: logIn()));
  
  final emailField = find.byKey(ValueKey('emailField'));
  final passwordField = find.byKey(ValueKey('passwordField'));
  final loginButton = find.byKey(ValueKey('loginButton'));
  
  // Provjera da li su polja prazna prije unosa
  expect(tester.widget<TextField>(emailField).controller!.text, '');
  expect(tester.widget<TextField>(passwordField).controller!.text, '');
  
  // Unos vrijednosti u polja
  await tester.enterText(emailField, 'test@example.com');
  await tester.enterText(passwordField, 'password123');
  
  // Provjera unesenih vrijednosti u poljima
  expect(tester.widget<TextField>(emailField).controller!.text, 'test@example.com');
  expect(tester.widget<TextField>(passwordField).controller!.text, 'password123');
  
  // Klik na login button
  await tester.tap(loginButton);
  await tester.pump();
  
  // Provjera da li je ostao na istom ekranu
  expect(find.byType(HomeScreen), findsNothing);
  expect(find.byType(logIn), findsOneWidget);
});

testWidgets('Test uspješnog logina', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: logIn()));
  
  final emailField = find.byKey(ValueKey('emailField'));
  final passwordField = find.byKey(ValueKey('passwordField'));
  final loginButton = find.byKey(ValueKey('loginButton'));
  
  await tester.enterText(emailField, 'test@example.com');
  await tester.enterText(passwordField, 'password123');
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
  
  // Provjera da li se navigirao na HomeScreen nakon uspješnog logina
  expect(find.byType(HomeScreen), findsOneWidget);
});


testWidgets('Test neuspješnog logina', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: logIn()));
  
  final emailField = find.byKey(ValueKey('emailField'));
  final passwordField = find.byKey(ValueKey('passwordField'));
  final loginButton = find.byKey(ValueKey('loginButton'));
  
  await tester.enterText(emailField, 'test@example.com');
  await tester.enterText(passwordField, 'invalidpassword');
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
  
  // Provjera da li se nije navigirao na HomeScreen nakon neuspješnog logina
  expect(find.byType(HomeScreen), findsNothing);
  expect(find.byType(logIn), findsOneWidget);
});

testWidgets('Validacija obrasca za registraciju - prazna polja', (WidgetTester tester) async {

    await tester.pumpWidget(Register());

    final registerButton = find.text('Register');

  
    await tester.tap(registerButton);
    await tester.pump();

   
    expect(find.text('Nevažeća adresa'), findsOneWidget);
    expect(find.text('Ime mora sadržavati najmanje jedan abecedni znak'), findsNWidgets(2));
    expect(find.text('Korisničko ime ne može biti prazno'), findsOneWidget);
    expect(find.text('Lozinka mora biti duža od 10 znakova'), findsOneWidget);
    expect(find.text('Lozinke se ne podudaraju'), findsOneWidget);
    expect(find.text('Nevažeća adresa'), findsOneWidget);
    expect(find.text('Nevažeći telefonski broj'), findsOneWidget);
  });


 testWidgets('Validacija obrasca za registraciju - važeća polja', (WidgetTester tester) async {
    
    await tester.pumpWidget(Register());

    
    final registerButton = find.text('Register');

    
    await tester.enterText(find.byType(TextFormField).at(0), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'John');
    await tester.enterText(find.byType(TextFormField).at(2), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(3), 'johndoe');
    await tester.enterText(find.byType(TextFormField).at(4), 'password123');
    await tester.enterText(find.byType(TextFormField).at(5), '123 Main St');
    await tester.enterText(find.byType(TextFormField).at(6), '1234-5678-9012-3456');
    await tester.enterText(find.byType(TextFormField).at(7), '1234567890');

    
    await tester.tap(registerButton);
    await tester.pump();

   
   expect(find.text('Nevažeća adresa'), findsOneWidget);
    expect(find.text('Ime mora sadržavati najmanje jedan abecedni znak'), findsNWidgets(2));
    expect(find.text('Korisničko ime ne može biti prazno'), findsOneWidget);
    expect(find.text('Lozinka mora biti duža od 10 znakova'), findsOneWidget);
    expect(find.text('Lozinke se ne podudaraju'), findsOneWidget);
    expect(find.text('Nevažeća adresa'), findsOneWidget);
    expect(find.text('Nevažeći telefonski broj'), findsOneWidget);
  });

testWidgets('Prisutno je dugme za registraciju', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Register()));

  expect(find.text('Register'), findsOneWidget);
});

testWidgets('Register - Form validation', (WidgetTester tester) async {
  await tester.pumpWidget(Register());

  await tester.tap(find.text('Register'));
  await tester.pump();

  expect(find.byType(AlertDialog), findsOneWidget);
  expect(find.text('Failure'), findsOneWidget);
  expect(find.text('User already exists'), findsOneWidget);
});

testWidgets('Google Sign-In Button Test', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Register(),
  ));

  expect(find.byType(SignInButton), findsOneWidget);
  expect(find.text('Register with Google'), findsOneWidget);

  await tester.tap(find.byType(SignInButton));
  await tester.pump();

  
});

testWidgets('Facebook Sign-In Button Test', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Register(),
  ));

  expect(find.byType(SignInButton), findsOneWidget);
  expect(find.text('Register with Facebook'), findsOneWidget);

  await tester.tap(find.byType(SignInButton));
  await tester.pump();

  
});







   
}
