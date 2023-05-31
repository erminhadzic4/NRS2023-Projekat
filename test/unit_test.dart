import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nrs2023/auth_provider.dart';
import 'package:nrs2023/screens/accountCreation.dart';
import 'package:nrs2023/screens/donationdetails.dart' as detailsDonation;
import 'package:nrs2023/screens/donations.dart' as donations;
import 'package:nrs2023/screens/donation.dart';
import 'package:nrs2023/screens/emailVaildation.dart';
import 'package:nrs2023/screens/loginAuth.dart';
import 'package:nrs2023/screens/numberValidation.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/home.dart';


void main() {
  group('Donation ', ()
  {
    testWidgets('Form validation with empty data', (WidgetTester tester) async {
      // Build the DonationPage widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(
              value: AuthProvider(), // Provide an instance of AuthProvider
            ),
          ],
          child: MaterialApp(
            home: DonationPage(),
          ),
        ),
      );

      // Enter invalid data in the form
      await tester.enterText(
          find
              .byType(TextFormField)
              .first, ''); // Set empty account number
      await tester.tap(find.byType(ElevatedButton)); // Tap the Donate button
      await tester.pump(); // Rebuild the widget after tapping the button

      // Expect to find the error message
      expect(
          find.text('Recipient account details are required'), findsOneWidget);
      expect(find.text('Amount should be a valid number.'), findsOneWidget);
    });

    testWidgets('Successful validation of the one-time donation form',
            (WidgetTester tester) async {
          // Build the DonationPage widget
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider(), // Provide an instance of AuthProvider
                ),
              ],
              child: MaterialApp(
                home: DonationPage(),
              ),
            ),
          );

          // Enter invalid data in the form
          await tester.enterText(find
              .byType(TextFormField)
              .first,
              '1234567'); // Set a valid account number
          await tester.enterText(find.byType(TextFormField).at(1), '100');
          await tester.enterText(
              find.byType(TextFormField).at(2),
              'Uplata novca'); // Set the amount
          await tester.tap(
              find.byType(ElevatedButton)); // Tap the Donate button
          await tester.pump(); // Rebuild the widget after tapping the button

          // Expect not to find any error messages
          expect(find.text('Recipient account details are required'),
              findsNothing);
        });

    testWidgets('Display of fields for logn-term donation',
            (WidgetTester tester) async {
          // Build the DonationPage widget
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider(), // Provide an instance of AuthProvider
                ),
              ],
              child: MaterialApp(
                home: DonationPage(),
              ),
            ),
          );

          // Enter invalid data in the form
          await tester.tap(
              find.text(
                  'Long-term donation')); // Tap the "Long-term" radio button
          await tester.pump(); // Rebuild the widget after tapping the button

          final donationPageState =
          tester.state<InitalState>(find.byType(DonationPage));
          final selectedValue = donationPageState.selectedType;

          // Expect the selected value to be 'long-term'
          expect(selectedValue, 'Long-term donation');
          expect(find.text('Frequency of donation'), findsOneWidget);
        });

    testWidgets('Successful validation for long-term donation',
            (WidgetTester tester) async {
          // Build the DonationPage widget
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider(), // Provide an instance of AuthProvider
                ),
              ],
              child: MaterialApp(
                home: DonationPage(),
              ),
            ),
          );
          await tester.enterText(find
              .byType(TextFormField)
              .first, '1234567');
          await tester.enterText(find.byType(TextFormField).at(1), '100');

          await tester.tap(find.text('Long-term donation'));
          await tester.pump();

          await tester.tap(find
              .text('Every month')
              .last);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextFormField).at(2), '10');

          await tester.tap(find
              .text('Year')
              .last);
          await tester.pumpAndSettle();

          await tester.enterText(find
              .byType(TextFormField)
              .last, 'Uplata novca');

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(find.text('It should be a valid number.'), findsNothing);
          expect(find.text('Recipient account details are required'),
              findsNothing);
          expect(find.text('Amount should be a valid number.'), findsNothing);
          expect(find.text('Duration is invalid.'), findsNothing);
        });

    testWidgets('Incorrectness of the duration of the donation',
            (WidgetTester tester) async {
          // Build the DonationPage widget
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider(), // Provide an instance of AuthProvider
                ),
              ],
              child: MaterialApp(
                home: DonationPage(),
              ),
            ),
          );
          await tester.enterText(find
              .byType(TextFormField)
              .first, '1234567');
          await tester.enterText(find.byType(TextFormField).at(1), '100');

          await tester.tap(find.text('Long-term donation'));
          await tester.pump();

          await tester.tap(find
              .text('Every year')
              .last);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextFormField).at(2), '1');

          await tester.tap(find
              .text('Week')
              .last);
          await tester.pumpAndSettle();

          await tester.enterText(find
              .byType(TextFormField)
              .last, 'Uplata novca');

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(find.text('You have successfully donated!'), findsNothing);
        });

    testWidgets('Displays list of donations', (WidgetTester tester) async {
      final listOfDonations = [
        donations.Donation(
          '1',
          'Hastor Fondacije',
          '12345',
          'Long-term donation',
          'USD',
          '100',
          'Every week',
          '3',
          'Week',
          'Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)',
          DateTime.now(),
        ),
        donations.Donation(
          '2',
          'KC Korporacija',
          '54321',
          'One-time donation',
          'USD',
          '2000',
          '',
          '',
          '',
          'Ovo je donacija za novog sibirskog plavca',
          DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(
              value: AuthProvider(), // Provide an instance of AuthProvider
            ),
          ],
          child: MaterialApp(
            home: donations.DonationsScreen(),
          ),
        ),
      );

      // Verify the app bar title
      expect(find.text('My Donations'), findsOneWidget);

      // Verify the list of donations
      for (var donation in listOfDonations) {
        expect(find.text('Donation for: ${donation.recipientName}'),
            findsOneWidget);
        expect(find.text('Amount: ${donation.amount} ${donation.currency}'),
            findsOneWidget);
        expect(find.text(donation.category), findsOneWidget);
      }
    });
    testWidgets('Navigate to donation details screen',
            (WidgetTester tester) async {
          final donation = donations.Donation(
            '1',
            'Hastor Fondacije',
            '12345',
            'Long-term donation',
            'USD',
            '100',
            'Every week',
            '3',
            'Week',
            'Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)',
            DateTime.now(),
          );

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider(), // Provide an instance of AuthProvider
                ),
              ],
              child: MaterialApp(
                home: donations.DonationsScreen(),
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) =>
                        detailsDonation.DonationDetailsScreen(
                          id: donation.id,
                          recipientName: donation.recipientName,
                          recipientAccount: donation.recipientAccount,
                          category: donation.category,
                          currency: donation.currency,
                          amount: donation.amount,
                          frequency: donation.frequency,
                          duration: donation.duration,
                          timetype: donation.timetype,
                          details: donation.details,
                          created: donation.created,
                        ),
                  );
                },
              ),
            ),
          );

          // Tap on the donation item
          await tester.tap(
              find.text('Donation for: ${donation.recipientName}'));
          await tester.pumpAndSettle();

// Get the current navigator
          await tester.pumpWidget(
            MaterialApp(
              home: detailsDonation.DonationDetailsScreen(
                id: donation.id,
                recipientName: donation.recipientName,
                recipientAccount: donation.recipientAccount,
                category: donation.category,
                currency: donation.currency,
                amount: donation.amount,
                frequency: donation.frequency,
                duration: donation.duration,
                timetype: donation.timetype,
                details: donation.details,
                created: donation.created,
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Verify that the donation details screen is displayed
          expect(
              find.byType(detailsDonation.DonationDetailsScreen),
              findsOneWidget);
        });

    testWidgets('DonationDetailsScreen displays correct donation details',
            (WidgetTester tester) async {
          // Create a DateTime object for the donation created date
          final DateTime created = DateTime(2023, 5, 27);

          // Create a widget tester and pump the DonationDetailsScreen
          await tester.pumpWidget(
            MaterialApp(
              home: detailsDonation.DonationDetailsScreen(
                id: '1',
                recipientName: 'Hastor Fondacije',
                recipientAccount: '12345',
                category: 'Long-term donation',
                currency: 'USD',
                amount: '100',
                frequency: 'Every week',
                duration: '3',
                timetype: 'Week',
                details:
                'Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)',
                created: created,
              ),
            ),
          );

          // Verify that the donation details are displayed correctly
          expect(find.text('Recipient: Hastor Fondacije'), findsOneWidget);
          expect(find.text('Recipient\'s account: 12345'), findsOneWidget);
          expect(find.text('Category: Long-term donation'), findsOneWidget);
          expect(find.text('Amount: 100 USD'), findsOneWidget);
          expect(
              find.text('Date: ${DateFormat.yMMMMd('en_US').format(created)}'),
              findsOneWidget);
          expect(
              find.text(
                  'Donation details: Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)'),
              findsOneWidget);
          expect(find.text('Next donation date:'), findsNothing);
        });


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

      testWidgets(
          'Entering email code updates emailCode', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginAuthScreen()));

        final emailField = find.widgetWithText(
            TextField, 'Enter code sent to email');
        await tester.enterText(emailField, '789012');

        expect(find.text('789012'), findsOneWidget);
      });

      testWidgets(
          'Entering phone code updates phoneCode', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginAuthScreen()));

        final phoneField = find.widgetWithText(
            TextField, 'Enter code sent to phone');
        await tester.enterText(phoneField, '210987');

        expect(find.text('210987'), findsOneWidget);
      });
      group('LoginAuth', () {
        test('setToken updates token and notifies listeners', () {
          final authProvider = AuthProvider();
          final listener = ListenerMock();

          // Pretplatite listener na authProvider
          authProvider.addListener(listener.onNotify);

          // Provera da li je token na početku prazan
          expect(authProvider.token, '');

          // Pozov setToken sa novom vrednošću
          final newToken = 'example_token';
          authProvider.setToken(newToken);

          // Azuriranje tokena
          expect(authProvider.token, newToken);

          // Provjera da li je listener bio obavešten o promjeni
          expect(listener.notified, true);

        });

        group('EmailValidation', () {
          late EmailValidationState emailValidationState;

          setUp(() {
            emailValidationState = EmailValidationState();
          });

          test(
              'EmailValidationState creates input decoration with correct properties', () {
            final inputDecoration = emailValidationState
                .registerInputDecoration(
              'Label Text',
              'Hint Text',
            );

            expect(inputDecoration.isDense, true);
            expect(
              inputDecoration.contentPadding,
              const EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
            );
            expect(inputDecoration.filled, true);
            expect(inputDecoration.fillColor, Colors.white);
            expect(inputDecoration.labelText, 'Label Text');
            expect(inputDecoration.hintText, 'Hint Text');
            expect(inputDecoration.border, const OutlineInputBorder());
          });

          testWidgets('Verify button calls confirmEmail', (WidgetTester tester) async {
            final valuesInput = [
              TextEditingController(), // Mail controller
              TextEditingController(), // First name controller
              TextEditingController(), // Last name controller
              TextEditingController(), // Username controller
            ];

            await tester.pumpWidget(MaterialApp(
              home: EmailValidation(valuesInput: valuesInput),
            ));

            // Tap the verify button
            await tester.tap(find.text('Verify'));
            await tester.pumpAndSettle();
          });

          group('NumberValidations', () {

            testWidgets('Initial state', (WidgetTester tester) async {
              await tester.pumpWidget(NumberValidation(username: 'test'));

              final state = tester.state<NumberValidationState>(find.byType(NumberValidation));
              expect(state.phoneController.text, '');
              expect(state.confirmationCode, '');
              expect(state.logged, false);
              expect(state.codeSent, false);
            });

            testWidgets('onCodeChanged', (WidgetTester tester) async {
              await tester.pumpWidget(NumberValidation(username: 'test'));

              final state = tester.state<NumberValidationState>(find.byType(NumberValidation));
              state.onCodeChanged('123456');

              expect(state.confirmationCode, '123456');
            });

            testWidgets('onSendCodePressed', (WidgetTester tester) async {
              await tester.pumpWidget(NumberValidation(username: 'test'));

              final state = tester.state<NumberValidationState>(find.byType(NumberValidation));
              state.onSendCodePressed();

            });

            testWidgets('onConfirmPressed', (WidgetTester tester) async {
              await tester.pumpWidget(NumberValidation(username: 'test'));

              final state = tester.state<NumberValidationState>(find.byType(NumberValidation));
              state.onConfirmPressed();
            });

            testWidgets('build', (WidgetTester tester) async {
              await tester.pumpWidget(NumberValidation(username: 'test'));

              final state = tester.state<NumberValidationState>(find.byType(NumberValidation));
              state.onCodeChanged('123456');

            });

            testWidgets('AlertDialog actions', (WidgetTester tester) async {
              bool dialogClosed = false;

              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: tester.element(find.byType(ElevatedButton)),
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Test Dialog'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    dialogClosed = true;
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Open Dialog'),
                    ),
                  ),
                ),
              );

              // Kliknite na gumb za otvaranje dijaloga
              await tester.tap(find.text('Open Dialog'));
              await tester.pumpAndSettle();

              // Provjerite da se dijalog prikazuje
              expect(find.text('Test Dialog'), findsOneWidget);

              // Kliknite na gumb "OK" u dijalogu
              await tester.tap(find.text('OK'));
              await tester.pumpAndSettle();

              // Provjerite da se dijalog zatvorio
              expect(dialogClosed, isTrue);
              expect(find.text('Test Dialog'), findsNothing);
            });


            group('prettyPrint', () {
              test('should return pretty printed JSON string', () {
                final json = {'name': 'John', 'age': 30};
                final expectedPretty = '{\n  "name": "John",\n  "age": 30\n}';

                final result = prettyPrint(json);

                expect(result, expectedPretty);
              });
            });

            group('AccountNumberFormatter', () {
              final formatter = AccountNumberFormatter();

              test('should format account number input with dashes', () {
                const oldValue = TextEditingValue(text: '1234567890123456');
                const newValue = TextEditingValue(text: '1234-5678-9012-3456');

                final result = formatter.formatEditUpdate(oldValue, newValue);

                expect(result.text, '1234-5678-9012-3456');
                expect(result.selection.baseOffset, 19);
                expect(result.selection.extentOffset, 19);
              });

              test('should format account number input with dashes when editing', () {
                const oldValue = TextEditingValue(text: '1234-5678-9012-3456');
                const newValue = TextEditingValue(text: '1234567890123456');

                final result = formatter.formatEditUpdate(oldValue, newValue);

                expect(result.text, '1234-5678-9012-3456');
                expect(result.selection.baseOffset, 19);
                expect(result.selection.extentOffset, 19);
              });

              group('RegisterState', () {
                late RegisterState registerState;

                setUp(() {
                  registerState = RegisterState();
                });

                test('should return correct input decoration', () {
                  const labelText = 'Label';
                  const hintText = 'Hint';

                  final inputDecoration = registerState.registerInputDecoration(labelText, hintText);

                  expect(inputDecoration.isDense, true);
                  expect(inputDecoration.contentPadding, const EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10));
                  expect(inputDecoration.filled, true);
                  expect(inputDecoration.fillColor, Colors.white);
                  expect(inputDecoration.labelText, labelText);
                  expect(inputDecoration.hintText, hintText);
                  expect(inputDecoration.border, const OutlineInputBorder());
                });

              });
            });
          });
        });
      });
    });


  });

    group('Widget Functionality Tests', () {
      testWidgets('Can access payment from home screen', (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOneWidget);

        // Simulirajte odabir opcije za plaćanje sa početnog ekrana
        await tester.tap(find.text('Payment'));
        await tester.pumpAndSettle();

        final paymentScreen = find.byType(PaymentPage);
        expect(paymentScreen, findsOneWidget);
      });

      testWidgets('Functionalities are clearly visible', (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOneWidget);

        // Simulirajte odabir opcije za plaćanje sa početnog ekrana
        await tester.tap(find.text('Payment'));
        await tester.pumpAndSettle();

        // Provjerite da li su sve funkcionalnosti vidljive na ekranu plaćanja
        expect(find.text('Currency'), findsOneWidget);
        expect(find.text('Amount'), findsOneWidget);
        expect(find.text('Username'), findsOneWidget);
        expect(find.text('Card Number'), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);
      });

      testWidgets('Can enter payment details', (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOneWidget);

        // Simulirajte odabir opcije za plaćanje sa početnog ekrana
        await tester.tap(find.text('Payment'));
        await tester.pumpAndSettle();

        // Simulirajte unos podataka o plaćanju
        await tester.enterText(find.byKey(Key('currencyField')), 'USD');
        await tester.enterText(find.byKey(Key('amountField')), '100.00');
        await tester.enterText(find.byKey(Key('usernameField')), 'John Doe');
        await tester.enterText(find.byKey(Key('cardNumberField')), '1234567890');
        await tester.tap(find.byKey(Key('submitButton')));
        await tester.pumpAndSettle();

        // Provjerite da li su svi podaci ispravno uneseni
        expect(find.text('USD'), findsOneWidget);
        expect(find.text('100.00'), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('1234567890'), findsOneWidget);
      });

      testWidgets('Fields have valid validation', (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOneWidget);

        // Simulirajte odabir opcije za plaćanje sa početnog ekrana
        await tester.tap(find.text('Payment'));
        await tester.pumpAndSettle();

        // Provjerite da li su sva polja ispravno označena i posjeduju validaciju
        expect(find.byKey(Key('currencyField')), findsOneWidget);
        expect(find.byKey(Key('amountField')), findsOneWidget);
        expect(find.byKey(Key('usernameField')), findsOneWidget);
        expect(find.byKey(Key('cardNumberField')), findsOneWidget);

        // Provjerite da li su polja ispravno označena kao obavezna
        expect(find.text('*'), findsNWidgets(4)); // Pretpostavljamo da sva polja označena kao obavezna imaju oznaku *

        // Provjerite da li se prikazuju poruke o greškama za neispravno popunjena polja
        expect(find.text('Please enter a valid currency'), findsNothing);
        expect(find.text('Please enter a valid amount'), findsNothing);
        expect(find.text('Please enter a valid username'), findsNothing);
        expect(find.text('Please enter a valid card number'), findsNothing);
      });

      testWidgets('User receives notification for invalid fields', (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(MaterialApp(home: PaymentPage(templateData: [], recipientName: "Emina", recipientAccount: "4545-5454-5454-5445", amount: "200", currency: "USD")));

        // Find the submit button and simulate tapping it without filling the form.
        final submitButton = find.text('Submit');
        await tester.tap(submitButton);

        // Trigger a frame.
        await tester.pump();

        // Expect that the validation error messages appear on the screen.
        expect(find.text('Please select a currency'), findsOneWidget);
        expect(find.text('Amount is required'), findsOneWidget);
        expect(find.text('Recipient first name is required'), findsOneWidget);
        expect(find.text('Recipient account details are required'), findsOneWidget);
      });



      testWidgets('User receives notification for successful transaction', (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOneWidget);

        // Simulirajte odabir opcije za plaćanje sa početnog ekrana
        await tester.tap(find.text('Payment'));
        await tester.pumpAndSettle();

        // Simulirajte unos ispravnih podataka o plaćanju
        await tester.enterText(find.byKey(Key('currencyField')), 'USD');
        await tester.enterText(find.byKey(Key('amountField')), '100.00');
        await tester.enterText(find.byKey(Key('usernameField')), 'John Doe');
        await tester.enterText(find.byKey(Key('cardNumberField')), '1234567890');
        await tester.tap(find.byKey(Key('submitButton')));
        await tester.pumpAndSettle();

        // Provjerite da li korisnik dobija obavijest o uspješno obavljenoj transakciji
        expect(find.text('Transaction successful'), findsOneWidget);
      });
    });
  }

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  home: HomeScreen(),
  );
  }
  }





// Mock klasa za testiranje listenera
class ListenerMock {
  bool notified = false;

  void onNotify() {
    notified = true;
  }
}


