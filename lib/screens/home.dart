import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nrs2023/screens/accountList.dart';
import 'package:nrs2023/screens/accountCreation.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:nrs2023/screens/welcome.dart';
import 'package:nrs2023/screens/donations.dart';
import 'package:nrs2023/screens/voucher.dart';
import 'package:http/http.dart' as http;

class Account {
  final String accountNumber;
  final String currency;
  final String bankName;
  final int credit;
  final int debit;
  final int total;
  final String owner;
  const Account(
      {required this.accountNumber,
      required this.currency,
      required this.bankName,
      required this.credit,
      required this.debit,
      required this.total,
      required this.owner});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountNumber: json['accountNumber'] as String,
      currency: json['currency'],
      bankName: json['bankName'],
      credit: json['credit'],
      debit: json['debit'],
      total: json['total'],
      owner: json['owner']['name'],
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String dropdownValue;
  late List<Account> accounts;
  late Future<List<Account>> futureAccounts;
  final storage = const FlutterSecureStorage();
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    dropdownValue = '';
    futureAccounts = fetchAccounts();
  }

  Future<List<Account>> fetchAccounts() async {
    String? token = await storage.read(key: 'token');
    print(token);
    final response = await http.get(
      Uri.parse(
          'http://siprojekat.duckdns.org:5051/api/Exchange/GetUserAccounts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var res = parseAccounts(response.body);
      print(response.body);

      // Simulate a delayed response using Future.delayed
      return Future.delayed(const Duration(seconds: 2), () {
        return parseAccounts(response.body);
      });
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  void onAccountSelected(String accountNumber) {
    print('Selected account: $accountNumber');
    selectedAccount = accounts
        .firstWhere((account) => account.accountNumber == accountNumber);
  }

  void showDetails() {
    if (selectedAccount != null) {
      print('Show details Selected account: ${selectedAccount!.accountNumber}');
    } else {
      print('No account selected');
    }
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
          filterSortingOrder: 'createdAtAsc',
        ),
      ),
    );
  }

  void clearSelection() {
    print('Clear clicked');
    setState(() {
      dropdownValue = '';
    });
    selectedAccount = const Account(
        accountNumber: 'Null',
        currency: 'Null',
        bankName: 'Null',
        credit: 0,
        debit: 0,
        total: 0,
        owner: 'Null');
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
                          // code to clear stored user data
                          // logInScreen.logout(context);

                          // navigate to the login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
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
        child: FutureBuilder<List<Account>>(
          future: futureAccounts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch accounts');
            } else if (snapshot.hasData) {
              accounts = snapshot.data!;
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Accounts',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Account Details'),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Account Number: ${account.accountNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Owner: ${account.owner}'),
                                      Text('Debit: \$${account.debit}'),
                                      Text('Bank Name: ${account.bankName}'),
                                      Text('Credit: \$${account.credit}'),
                                      Text('Total: \$${account.total}'),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .blue, // Customize the button color
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    account.accountNumber,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    account.currency,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              tileColor: dropdownValue == account.accountNumber
                                  ? Colors.blue[100]
                                  : null,
                              onTap: () {
                                setState(() {
                                  dropdownValue = account.accountNumber;
                                });
                                onAccountSelected(account.accountNumber);
                              },
                            ),
                          ),
                        );
                      },
                    )),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: showDetails,
                          child: const Text('Show details'),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: clearSelection,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Text('No accounts found');
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const accountCreation()),
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
                    ),
                  ),
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
                      filterSortingOrder: 'createdAtAsc',
                    ),
                  ),
                );
              },
              tooltip: 'Transaction History',
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.gift),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationsScreen()),
                );
              },
              tooltip: 'Donations',
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
