import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:nrs2023/auth_provider.dart';
import 'package:nrs2023/screens/accountCreation.dart';
import 'package:nrs2023/screens/claim.dart';
import 'package:nrs2023/screens/donationdetails.dart' as detailsDonation;
import 'package:nrs2023/screens/donations.dart' as donations;
import 'package:nrs2023/screens/donation.dart';
import 'package:nrs2023/screens/emailVaildation.dart';
import 'package:nrs2023/screens/grouping.dart' as groupings;
import 'package:nrs2023/screens/loginAuth.dart';
import 'package:nrs2023/screens/numberValidation.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:nrs2023/screens/transactions.dart' as transactions;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/filters.dart' as filters;
import 'package:http/http.dart' as http;



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
              testWidgets('Test TransactionDetailsScreen UI', (WidgetTester tester) async {
                // Arrange
                final transactionId = '123';
                final transactionCurrency = 'USD';
                final transactionType = 'Payment';
                final transactionAmount = 100.0;
                final transactionDate = DateTime(2023, 5, 30);
                final transactionDetails = 'Payment for goods';
                final recipientName = 'John Doe';
                final recipientAccount = '1234567890';

                final expectedAmountText = '${transactionAmount.toStringAsFixed(2)} $transactionCurrency';
                final expectedDateText = DateFormat.yMMMMd('en_US').format(transactionDate);

                // Act
                await tester.pumpWidget(
                  MaterialApp(
                    home: TransactionDetailsScreen(
                      transactionId: transactionId,
                      transactionCurrency: transactionCurrency,
                      transactionType: transactionType,
                      transactionAmount: transactionAmount,
                      transactionDate: transactionDate,
                      transactionDetails: transactionDetails,
                      recipientName: recipientName,
                      recipientAccount: recipientAccount,
                    ),
                  ),
                );
                await tester.pumpAndSettle();

                // Assert
                expect(find.text('Details'), findsOneWidget);
                expect(find.text('Transaction Details'), findsWidgets);
                expect(find.text('Transaction Amount'), findsWidgets);
                expect(find.text(expectedAmountText), findsWidgets);
                expect(find.text('Recipient Name'), findsWidgets);
                expect(find.text(recipientName), findsWidgets);
                expect(find.text('Transaction Type'), findsWidgets);
                expect(find.text(transactionType), findsWidgets);
                expect(find.text('Transaction Details'), findsWidgets);
                expect(find.text(transactionDetails), findsWidgets);

                expect(find.text('Transaction Date'), findsWidgets);
                expect(find.text(expectedDateText), findsWidgets);
                expect(find.text('Transaction ID'), findsWidgets);
                expect(find.text(transactionId), findsWidgets);
                expect(find.widgetWithText(ElevatedButton, 'Use as Template'), findsWidgets);
                expect(find.widgetWithText(ElevatedButton, 'Claim'), findsWidgets);

              });

              testWidgets('Test TransactionDetailsScreen button navigation', (WidgetTester tester) async {
                // Arrange
                final transactionId = '123';
                final recipientName = 'John Doe';
                final recipientAccount = '1234567890';
                final transactionAmount = 100.0;
                final transactionCurrency = 'USD';

                // Act
                await tester.pumpWidget(
                  MaterialApp(
                    home: TransactionDetailsScreen(
                      transactionId: transactionId,
                      transactionCurrency: transactionCurrency,
                      transactionType: 'Payment',
                      transactionAmount: transactionAmount,
                      transactionDate: DateTime.now(),
                      transactionDetails: 'Payment for goods',
                      recipientName: recipientName,
                      recipientAccount: recipientAccount,
                    ),
                  ),
                );

                await tester.pumpAndSettle();

                // Tap on "Use as Template" button
                await tester.tap(find.widgetWithText(ElevatedButton, 'Use as Template'));
                await tester.pumpAndSettle();

                // Assert
                expect(find.byType(PaymentPage), findsWidgets);
                expect(find.byType(ClaimPage), findsNothing);
              });
              testWidgets('Test Transaction History ', (WidgetTester tester) async {

                var token ="proba";
                var userId;
                final res = await http.post(Uri.parse("http://siprojekat.duckdns.org:5051/api/User/login"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      "email": "damke23@gmail.com",
                      "password": "Jabuka32!",
                    }));
                if (res.statusCode == 200) {
                  var responseData = jsonDecode(res.body);
                  token = responseData['token'].toString();
                  userId = responseData['userId'];
                }


              });
              testWidgets('FiltersScreen - Dropdown selection test', (WidgetTester tester) async {
                // Build FiltersScreen widget
                await tester.pumpWidget(MaterialApp(home: filters.FiltersScreen(
                  textEditingController1: TextEditingController(),
                  textEditingController2: TextEditingController(),
                  textEditingController3: TextEditingController(),
                  textEditingController4: TextEditingController(),
                  textEditingController5: TextEditingController(),
                  textEditingController6: TextEditingController(),
                  selectedDates: DateTimeRange(start: DateTime.utc(1900, 1, 1), end: DateTime.now()),
                  selectedCurrency: "All",
                  selectedTransactionType: "All",
                  selectedFilterSortingOrder: "createdAtAsc",
                )));

                // Open the Transaction Type dropdown
                await tester.tap(find.byKey(const ValueKey('transactionTypeDropdown')));
                await tester.pumpAndSettle();

                // Select a transaction type from the dropdown
                await tester.tap(find.text("c2c").last);
                await tester.pumpAndSettle();

                // Verify that the selected transaction type is updated
                expect(find.text("c2c"), findsOneWidget);
              });

              testWidgets('Submitting claim should call createClaim API', (tester) async {
                // Build the widget
                await tester.pumpWidget(
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AuthProvider>.value(
                        value: AuthProvider(), // Provide an instance of AuthProvider
                      ),
                    ],
                    child: MaterialApp(
                      home: ClaimPage(transactionId: 123),
                    ),
                  ),
                );

                // Enter subject and description
                await tester.enterText(
                    find.byKey(const ValueKey('subjectField')), 'Test Subject');
                await tester.enterText(
                    find.byKey(const ValueKey('descriptionField')), 'Test Description');

                // Tap the Submit Claim button
                await tester.tap(find.text('Submit Claim'));
                await tester.pumpAndSettle();

                // Verify that createClaim API is called with the correct parameters
                // Enter subject and description
                await tester.enterText(
                    find.byKey(const ValueKey('subjectField')), 'Test Subject');
                await tester.enterText(
                    find.byKey(const ValueKey('descriptionField')), 'Test Description');

                // Tap the Submit Claim button
                await tester.tap(find.text('Submit Claim'));
                await tester.pumpAndSettle();

                // Verify that the message is updated with the expected value
                expect(find.text('File uploaded succesfully'), findsNothing);
              });

              testWidgets('Test Transactions screen', (WidgetTester tester) async {
                // Build the screen

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
                          builder: (context) => transactions.Transactions(
                            filterDateStart: DateTime.now(),
                            filterDateEnd: DateTime.now(),
                            filterCurrency: 'USD',
                            filterTransactionType: 'All',
                            filterPriceRangeStart: '0',
                            filterPriceRangeEnd: '100',
                            filterRecipientName: '',
                            filterRecipientAccount: '',
                            filterSenderName: '',
                            filterCategory: '',
                            filterSortingOrder: '',
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
            });
          });
        });
      });
    });
  });
}


// Mock klasa za testiranje listenera
class ListenerMock {
  bool notified = false;

  void onNotify() {
    notified = true;
  }





}


