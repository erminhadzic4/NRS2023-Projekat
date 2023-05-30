import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nrs2023/auth_provider.dart';
import 'package:nrs2023/screens/donationdetails.dart' as detailsDonation;
import 'package:nrs2023/screens/donations.dart' as donations;
import 'package:nrs2023/screens/donation.dart';
import 'package:provider/provider.dart';

void main() {
  group('Donation ', () {
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
          find.byType(TextFormField).first, ''); // Set empty account number
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
      await tester.enterText(find.byType(TextFormField).first,
          '1234567'); // Set a valid account number
      await tester.enterText(find.byType(TextFormField).at(1), '100');
      await tester.enterText(
          find.byType(TextFormField).at(2), 'Uplata novca'); // Set the amount
      await tester.tap(find.byType(ElevatedButton)); // Tap the Donate button
      await tester.pump(); // Rebuild the widget after tapping the button

      // Expect not to find any error messages
      expect(find.text('Recipient account details are required'), findsNothing);
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
          find.text('Long-term donation')); // Tap the "Long-term" radio button
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
      await tester.enterText(find.byType(TextFormField).first, '1234567');
      await tester.enterText(find.byType(TextFormField).at(1), '100');

      await tester.tap(find.text('Long-term donation'));
      await tester.pump();

      await tester.tap(find.text('Every month').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), '10');

      await tester.tap(find.text('Year').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).last, 'Uplata novca');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('It should be a valid number.'), findsNothing);
      expect(find.text('Recipient account details are required'), findsNothing);
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
      await tester.enterText(find.byType(TextFormField).first, '1234567');
      await tester.enterText(find.byType(TextFormField).at(1), '100');

      await tester.tap(find.text('Long-term donation'));
      await tester.pump();

      await tester.tap(find.text('Every year').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), '1');

      await tester.tap(find.text('Week').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).last, 'Uplata novca');

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
                builder: (context) => detailsDonation.DonationDetailsScreen(
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
      await tester.tap(find.text('Donation for: ${donation.recipientName}'));
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
          find.byType(detailsDonation.DonationDetailsScreen), findsOneWidget);
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
      expect(find.text('Date: ${DateFormat.yMMMMd('en_US').format(created)}'),
          findsOneWidget);
      expect(
          find.text(
              'Donation details: Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)'),
          findsOneWidget);
      expect(find.text('Next donation date:'), findsNothing);
    });
  });
}
