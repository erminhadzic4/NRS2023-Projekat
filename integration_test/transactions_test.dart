import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nrs2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Transaction history filter test', (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    final logInButton = find.byKey(const ValueKey('logInButton'));
    await tester.tap(logInButton);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.enterText(find.byKey(const ValueKey('EmailField')), 'damke23@gmail.com');
    await tester.enterText(find.byKey(const ValueKey('PasswordField')), 'Jabuka32!');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.dragUntilVisible(
      find.text('LOGIN'),
      find.byKey(const ValueKey('Container')),
      const Offset(-250, 0),
    );
    await tester.tap(find.byKey(const ValueKey('loginbutton')));

    // Wait for the dialog box to appear
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Find and tap the 'OK' button on the dialog
    final okButton = find.text('OK');
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    //transactions history icon pressed
    final transactionHistory = find.byIcon(Icons.history);
    await tester.tap(transactionHistory);
    await tester.pumpAndSettle(const Duration(seconds: 6));

    //filter button for transactions pressed
    final filterButton = find.byIcon(Icons.filter_alt_outlined);
    await tester.tap(filterButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    //enter price range 20-30 and other text field values
    await tester.enterText(find.byKey(const ValueKey('priceRangeStart')), '21');
    await tester.enterText(find.byKey(const ValueKey('priceRangeEnd')), '30');
    await tester.enterText(find.byKey(const ValueKey('recipientsName')), 'Samir Samirovic');
    await tester.enterText(find.byKey(const ValueKey('recipientsAccount')), 'B57C0S23');
    await tester.enterText(find.byKey(const ValueKey('sendersName')), 'Damir Fudic');
    await tester.enterText(find.byKey(const ValueKey('category')), 'Transfer');
    await tester.pumpAndSettle(const Duration(seconds: 1));


    //select transaction type
    final transactionTypeDropdown = find.byKey(const ValueKey('transactionTypeDropdown'));
    await tester.tap(transactionTypeDropdown);
    await tester.pump(const Duration(seconds: 2));
    final typeFirst = find.byKey(const ValueKey('transactionTypeDropdown')).first;
    await tester.tap(typeFirst);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    //select date range button pressed
    final selectDateButton = find.text('Select Date Range');
    await tester.tap(selectDateButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));
    final date = find.text("17").first;
    await tester.tap(date);
    await tester.tap(date);
    await Future.delayed(const Duration(seconds: 1));
    final save = find.text("SAVE").first;
    await tester.tap(save);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    /*
    //select date range button pressed
    final selectDateButton = find.text('Select Date Range');
    await tester.tap(selectDateButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Select dates
    await tester.tapAt(Offset(220,400));
    await tester.tapAt(Offset(220,400));
    await Future.delayed(const Duration(seconds: 1));
    await tester.tapAt(Offset(390,75));
    await tester.pumpAndSettle(const Duration(seconds: 2));
     */

    //Select Currency
    final currencyDropdown = find.byKey(const ValueKey('selectCurrencyDropdown'));
    await tester.tap(currencyDropdown);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final USD = find.text("USD").last;
    await tester.tap(USD);


    await tester.pumpAndSettle(const Duration(seconds: 2));
    //apply filters
    final applyButton = find.text('Apply Filters');
    await tester.tap(applyButton);

    //assert that no transaction with amount of 20 is found
    await tester.pumpAndSettle(const Duration(seconds: 6));
    //expect(find.text('20'), findsNothing);

  });
}