import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/transactionExchange.dart';
import 'package:http/http.dart' as http;

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
  String account;

  Accounts(
      {required this.currency, required this.bankName, required this.account});

  String toJson() {
    return json.encode({
      'currency': currency,
      'bankName': bankName,
      'account': account,
    });
  }

  static Accounts fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Accounts(
      currency: jsonMap['currency'],
      bankName: jsonMap['bankName'],
      account: jsonMap['account'],
    );
  }
}

class _AccountListPageState extends State<AccountListPage> {
  List<Accounts> _accounts = [];
  final storage = FlutterSecureStorage();

  Future getUserAccounts() async {
    _accounts.clear();
    String? token = await storage.read(key: 'token');
    print(token);
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    final getAccounts = await http.get(
        Uri.parse(
            'http://siprojekat.duckdns.org:5051/api/Exchange/GetUserAccounts'),
        headers: headers);

    var accountsList = json.decode(getAccounts.body);

    for (int i = 0; i < accountsList.length; i++) {
      String currency = accountsList[i]['currency'];
      String bankName = accountsList[i]['bankName'];
      String accountNumber = accountsList[i]['accountNumber'];

      var account = Accounts(
          currency: currency, bankName: bankName, account: accountNumber);
      _accounts.add(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: FutureBuilder(
        future: getUserAccounts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
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
                              builder: (context) => TransactionExchangePage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                templateData: ["", "", "", ""],
                                recipientName: "",
                                recipientAccount: _accounts[index].account,
                                amount: '',
                                currency: _accounts[index].currency,
                                //accountNumber: _accounts[index].account
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
