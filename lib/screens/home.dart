import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nrs2023/screens/accountList.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/accountCreation.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:nrs2023/screens/logIn.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:nrs2023/screens/welcome.dart';
import 'package:nrs2023/screens/voucher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth_provider.dart';


class Account {
  final String accountNumber;
  const Account({
      required this.accountNumber,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        accountNumber: json['accountNumber'] as String,
    );
  }
}
List<Account> parseAccounts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Account>((json) => Account.fromJson(json)).toList();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var token;
  late final LocalAuthentication auth;
  bool _supportState = false;
  String? dropdownValue;
  late List<Account> Accounts = [];
  List<String> accountNumbers = [];
  late Future<List<Account>> futureAccounts;
  final storage = new FlutterSecureStorage();
  final logIn logInScreen = const logIn();

  String getSelectedAccountText() {
    if (dropdownValue == null) {
      return 'Selected Account: ';
    } else {
      return 'Selected Account:\n $dropdownValue';
    }
  }

  @override
  void initState(){
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
      _supportState = isSupported;
    }));
    //Accounts.add(Account(accountNumber: "No account selected"));
    //dropdownValue = Accounts[this.Accounts.length - 1].accountNumber;
    fetchAccounts().then((List<Account> Accounts){
      setState(() {
        for(var i = 0; i < this.Accounts.length; i++){
          print(this.Accounts[i].accountNumber);
        }
        //Accounts.add(Account(accountNumber: "No account selected"));
        this.Accounts = Accounts;
        //dropdownValue = Accounts[this.Accounts.length - 1].accountNumber;
        //this.Accounts.add(Account(accountNumber: "No account selected"));
        //dropdownValue = Accounts[0].accountNumber;
        //this.Accounts.add(Account(accountNumber: "No account selected"));
        //dropdownValue = Accounts[this.Accounts.length - 1].accountNumber;
      });
    });
  }

  Future<List<Account>> fetchAccounts() async {
    String? token = await storage.read(key: 'token');
    print(token);
    final response = await http.get(
        Uri.parse('http://siprojekat.duckdns.org:5051/api/Exchange/GetUserAccounts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      // Ako server vrati status kod 200,
      // parsiraj JSON.
      var res = parseAccounts(response.body);
      print(res[0].accountNumber);
      return parseAccounts(response.body);
    } else {
      // Ako server ne vrati status kod 200,
      // baci izuzetak.
      throw Exception('Failed to load account');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('LOGOUT'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          // kod za brisanje pohranjenih korisničkih podataka
                          logInScreen.logout(context);

                          // navigacija na stranicu prijave
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 25.0),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                textAlign: TextAlign.center,
                'Please choose an account:',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(
                height: 20,
              ),
              // Step 2.
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent, //<-- SEE HERE
            ),
            child: DropdownButton(
              value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;// ?? 'No account selected';
                  });
                },
                items: Accounts.map((Account data) {
                  return DropdownMenuItem<String>(
                    value: data.accountNumber,
                    child: Text(
                      data.accountNumber,
                      style: const TextStyle(fontSize: 15.5)
                    ),
                  );
                }).toList(),
              )
            ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 24.0),
                    text: dropdownValue == null ? 'Selected Account: ' : 'Selected Account:\n$dropdownValue'
                )
               // textAlign: TextAlign.center,
                //'Selected Account:\n$dropdownValue',
               // style: const TextStyle(fontSize: 24.0),
              //  data: dropdownValue == null ? 'Selected Account: ' : 'Selected Account:\n$dropdownValue',
              )
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const accountCreation()),
                );
              },
              tooltip: 'Create Account',
            ),
            IconButton(
              icon: const Icon(Icons.payment),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountListPage(
                        currency: ["", "", "", ""],
                        bankName: '',
                        description: '',
                      )),
                );
              },
              tooltip: 'Make Payment',
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Transactions(
                          filterDateStart: DateTime.utc(1900, 1, 1),
                          filterDateEnd: DateTime.now(),
                          filterCurrency: 'All',
                          filterTransactionType: 'All',
                          filterPriceRangeStart: '0',
                          filterPriceRangeEnd: '100000',
                          filterRecipientName: '',
                          filterRecipientAccount: '',
                          filterSenderName: '',
                          filterCategory: '',
                          filterSortingOrder: 'createdAtAsc')),
                );
              },
              tooltip: 'Transaction History',
            ),
            IconButton(
              icon: const Icon(Icons.card_giftcard),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoucherScreen()),
                );
              },
              tooltip: 'Vouchers',
            ),
          ],
        ),
      ),
    );
  }
}

