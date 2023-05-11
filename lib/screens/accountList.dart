import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/transactionExchange.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage(
      {Key? key,
      required this.currency,
      required String bankName,
      required String description})
      : super(key: key);
  final List currency;

  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class Accounts {
  String currency;
  String bankName;
  String description;

  Accounts(
      {required this.currency,
      required this.bankName,
      required this.description});

  String toJson() {
    return json.encode({
      'currency': currency,
      'bankName': bankName,
      'description': description,
    });
  }

  static Accounts fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Accounts(
      currency: jsonMap['currency'],
      bankName: jsonMap['bankName'],
      description: jsonMap['description'],
    );
  }
}

class _AccountListPageState extends State<AccountListPage> {
  List<Accounts> _accounts = [
    Accounts(
        currency: 'USD', bankName: 'Bank1', description: 'Savings account'),
    Accounts(
        currency: 'EUR', bankName: 'Bank2', description: 'Checking account'),
    Accounts(
        currency: 'GBP', bankName: 'Bank3', description: 'Credit card account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: ListView.builder(
        itemCount: _accounts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_accounts[index].bankName),
            subtitle: Text(_accounts[index].currency),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.compare_arrows),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionExchangePage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(
                          templateData: ["", "", "", ""],
                          recipientName: '',
                          recipientAccount: '',
                          amount: '',
                          currency: '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
