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

  Accounts({
    required this.currency,
    required this.bankName,
    required this.description
  });

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
  final _formKey = GlobalKey<FormState>();
  final _currencyController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Accounts> _accounts = [
    Accounts(currency: 'USD',
        bankName: 'Bank1',
        description: 'Savings account'),
    Accounts(currency: 'EUR',
        bankName: 'Bank2',
        description: 'Checking account'),
    Accounts(currency: 'GBP',
        bankName: 'Bank3',
        description: 'Credit card account'),
  ];
  String _selectedCurrency = "USD";
  final List<String> _currencies = [
    'USD',
    'AUD',
    'BRL',
    'CAD',
    'CHF',
    'CZK',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'HUF',
    'ILS',
    'JPY',
    'MXN',
    'NOK',
    'NZD',
    'PHP',
    'PLN',
    'RUB',
    'SEK',
    'SGD',
    'THB',
    'TWD'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 16),
                            Text('Currency'),
                            DropdownButtonFormField<String>(
                              value: _selectedCurrency,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                              items: _currencies
                                  .map((currency) => DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              ))
                                  .toList(),
                            ),
                            TextFormField(
                              controller: _bankNameController,
                              decoration: InputDecoration(
                                labelText: 'Bank Name',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a bank name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final account = Accounts(
                              currency: _currencyController.text,
                              bankName: _bankNameController.text,
                              description: _descriptionController.text,
                            );
                            _accounts.add(account);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Account created')),
                            );
                          }
                        },
                        child: Text('Create'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                      MaterialPageRoute(builder: (context) => TransactionExchangePage()),
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