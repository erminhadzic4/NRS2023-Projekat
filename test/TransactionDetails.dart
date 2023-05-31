import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nrs2023/screens/claim.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/transactionDetails.dart';

void main() {
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
/*
    // Tap on "Claim" button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Claim'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(PaymentPage), findsNothing);
    expect(find.byType(ClaimPage), findsWidgets);
*/

  });
}