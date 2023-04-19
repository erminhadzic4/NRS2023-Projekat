import 'package:flutter/material.dart';
import 'package:nrs2023/screens/pay.dart';

class ReceivedTransactionPage extends StatefulWidget {
  final Transaction transaction;

  ReceivedTransactionPage({Key? key, required this.transaction}) : super(key: key);

  @override
  _ReceivedTransactionPageState createState() => _ReceivedTransactionPageState();
}

class _ReceivedTransactionPageState extends State<ReceivedTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Received Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display transaction details here
            // ...

            // Add a button to execute the transaction
            ElevatedButton(
              onPressed: () async {
                // Execute the transaction using the validateTransaction() function
                // ...
              },
              child: Text('Execute Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

