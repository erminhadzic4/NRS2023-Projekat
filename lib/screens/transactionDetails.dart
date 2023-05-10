import 'dart:core';

import 'package:flutter/material.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:intl/intl.dart';
import 'package:nrs2023/screens/claim.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;
  final String transactionCurrency;
  final String transactionType;
  final double transactionAmount;
  final DateTime transactionDate;
  final String transactionDetails;
  final String recipientName;
  final String recipientAccount;

  TransactionDetailsScreen({
    required this.transactionId,
    required this.transactionCurrency,
    required this.transactionType,
    required this.transactionAmount,
    required this.transactionDate,
    required this.transactionDetails,
    required this.recipientName,
    required this.recipientAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          //Title
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),

          //Transaction Amount
          ListTile(
            title: Text(
              'Transaction Amount',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${transactionAmount.toStringAsFixed(2)}' +
                  ' ' +
                  transactionCurrency,
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),

          //Transaction Recipient name
          ListTile(
            title: Text(
              'Recipient Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              recipientName,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),

          //Transaction Type
          ListTile(
            title: Text(
              'Transaction Type',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              transactionType,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),

          //Transaction Details
          ListTile(
            title: Text(
              'Transaction Details',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              transactionDetails,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),

          //Transaction Date
          ListTile(
            title: Text(
              'Transaction Date',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat.yMMMMd('en_US').format(transactionDate),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),

          //Transaction ID
          ListTile(
            title: Text(
              'Transaction ID',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              transactionId,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[400]),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        recipientName: recipientName,
                        recipientAccount: recipientAccount,
                        amount: transactionAmount.toString(),
                        currency: transactionCurrency,
                        templateData: [
                          transactionCurrency,
                          transactionAmount.toString(),
                          recipientName,
                          recipientAccount
                        ],
                      ),
                    ));
              },
              child: Text('Use as Template'),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 180, 0, 0), // Background color
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClaimPage(
                              transactionId: int.parse(transactionId),
                            )));
              },
              child: Text('Claim'),
            ),
          ),
        ],
      ),
    );
  }
}
