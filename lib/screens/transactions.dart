import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:nrs2023/screens/filters.dart';
import 'package:nrs2023/screens/claims.dart';
import 'package:nrs2023/screens/grouping.dart';
import 'package:nrs2023/screens/donation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

// Implementacija klase Transaction
class Transaction {
  int transactionId;
  double amount;
  String currency;
  String transactionType;
  String transactionPurpose;
  String category;
  DateTime createdAt;
  User recipient;
  User sender;

  Transaction(
      this.transactionId,
      this.amount,
      this.currency,
      this.transactionType,
      this.transactionPurpose,
      this.category,
      this.createdAt,
      this.recipient,
      this.sender);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['transactionId'],
      json['amount'].toDouble(),
      json['currency'],
      json['transactionType'],
      json['transactionPurpose'],
      json['category'],
      DateTime.parse(json['createdAt']),
      User.fromJson(json['recipient']),
      User.fromJson(json['sender']),
    );
  }
}

// Implementacija klase User
class User {
  String name;
  String accountNumber;
  String bankName;
  String phoneNumber;
  String type;

  User({
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.type,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      type: json['type'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class Transactions extends StatefulWidget {
  late DateTime filterDateStart;
  late DateTime filterDateEnd;
  late String filterCurrency;
  late String filterTransactionType;
  late String filterPriceRangeStart;
  late String filterPriceRangeEnd;
  late String filterRecipientName;
  late String filterRecipientAccount;
  late String filterSenderName;
  late String filterCategory;
  late String filterSortingOrder;
  Transactions(
      {required this.filterDateStart,
      required this.filterDateEnd,
      required this.filterCurrency,
      required this.filterTransactionType,
      required this.filterPriceRangeStart,
      required this.filterPriceRangeEnd,
      required this.filterRecipientName,
      required this.filterRecipientAccount,
      required this.filterSenderName,
      required this.filterCategory,
      required this.filterSortingOrder});
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<Transactions> {
  var token;
  var transactions = <Transaction>[];
  var showntransactions = <Transaction>[];
  ScrollController _scrollController = ScrollController();
  int shownTransactionsLimit = 10;
  int _currentPage = 1;
  int _loadTransactionsLimit = 10;
  bool _isLoading = false;
  String searchValue = '';
  int cupertinoCounter = 1; // 1 znaci ON, 0 znaci OFF

//KOD Za povlacenje tranzakcija sa API-a

  @override
  void _cupertinoCheck() {
    if (shownTransactionsLimit != transactions.length) {
      cupertinoCounter = 0;
    } else {
      cupertinoCounter = 1;
    }
  }

  @override
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    print(token);
    _getMoreTransactions();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
        _getMoreTransactions();
      }
    });
  }

  //KOD za ucitavanje novih transakcija u prikaz
  _getMoreList() {
    shownTransactionsLimit = shownTransactionsLimit + 10;
    setState(() {});
  }

//KOD za podatke sa servera
  Future<void> _getMoreTransactions() async {
    _cupertinoCheck();
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    var startAmount = widget.filterPriceRangeStart;
    var endAmount = widget.filterPriceRangeEnd;
    var currency = widget.filterCurrency;
    var paymentType = widget.filterTransactionType;
    var recipientName = widget.filterRecipientName;
    var recipientAccountNumber = widget.filterRecipientAccount;
    var senderName = widget.filterSenderName;
    var dateStart = widget.filterDateStart;
    var dateEnd = widget.filterDateEnd;
    var category = widget.filterCategory;
    var sortingOrder = widget.filterSortingOrder;
    var link =
        "https://processingserver.herokuapp.com/api/Transaction/GetTransactionsForUser?token=$token&pageNumber=$_currentPage&pageSize=$_loadTransactionsLimit";
    link = link + "&AmountStartFilter=$startAmount&AmountEndFilter=$endAmount";
    if (currency != "All") {
      link = link + "&CurrencyFilter=$currency";
    }
    if (paymentType != 'All') {
      link = link + "&TransactionTypeFilter=$paymentType";
    }
    if (recipientName != '') {
      link = link + "&RecipientNameFilter=$recipientName";
    }
    if (recipientAccountNumber != '') {
      link = link + "&RecipientAccountNumberFilter=$recipientAccountNumber";
    }
    if (senderName != '') {
      link = link + "&RecipientAccountNumberFilter=$recipientAccountNumber";
    }
    link =
        link + "&CreatedAtStartFilter=$dateStart&CreatedAtEndFilter=$dateEnd";
    if (category != '') {
      link = link + "&CategoryFilter=$category";
    }
    link = link + "&sortingOrder=$sortingOrder";
    final url = Uri.parse(link);
    final response = await http.get(url);
    var counter = 0;
    final responseData = json.decode(response.body);
    responseData.forEach((transactionData) {
      counter++;
      showntransactions.add(Transaction.fromJson(transactionData));
      transactions.add(Transaction.fromJson(transactionData));
    });
    _cupertinoCheck();
    setState(() {
      //da li je ucitano onoliko tranzakcija koliko je pozvano ili je kraj
      if (counter == _loadTransactionsLimit) {
        _currentPage++;
        _isLoading = false;
      }
    });
  }

//KOD za podatke sa servera
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text("Transactions"),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Filter Transactions',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FiltersScreen(
                              selectedTransactionType:
                                  widget.filterTransactionType,
                              textEditingController1: TextEditingController(
                                  text: widget.filterPriceRangeStart),
                              textEditingController2: TextEditingController(
                                  text: widget.filterPriceRangeEnd),
                              textEditingController3: TextEditingController(
                                  text: widget.filterRecipientName),
                              textEditingController4: TextEditingController(
                                  text: widget.filterRecipientAccount),
                              textEditingController5: TextEditingController(
                                  text: widget.filterSenderName),
                              textEditingController6: TextEditingController(
                                  text: widget.filterCategory),
                              selectedDates: DateTimeRange(
                                  start: widget.filterDateStart,
                                  end: widget.filterDateEnd),
                              selectedCurrency: widget.filterCurrency,
                              selectedFilterSortingOrder:
                                  widget.filterSortingOrder,
                            )));
              }),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sort by"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Amount (ascending)"),
                        onTap: () {
                          // Sort transactions by amount (ascending)
                          widget.filterSortingOrder = "amountAsc";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                      ),
                      ListTile(
                        title: Text("Amount (descending)"),
                        onTap: () {
                          // Sort transactions by amount (descending)
                          widget.filterSortingOrder = "amountDesc";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                      ),
                      ListTile(
                        title: Text("Date (ascending)"),
                        onTap: () {
                          // Sort transactions by date (ascending)
                          widget.filterSortingOrder = "createdAtAsc";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                      ),
                      ListTile(
                        title: Text("Date (descending)"),
                        onTap: () {
                          // Sort transactions by date (descending)
                          widget.filterSortingOrder = "createdAtDesc";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.group_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Group by"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Currency"),
                        onTap: () {
                          // Group by currency
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupingScreen(
                                  link:
                                      "https://processingserver.herokuapp.com/api/Transaction/GroupTransactionsByCurrency?token=$token"),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text("Transaction Type"),
                        onTap: () {
                          // Group by type
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupingScreen(
                                  link:
                                      "https://processingserver.herokuapp.com/api/Transaction/GroupTransactionsByType?token=$token"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.warning_sharp),
              tooltip: 'My Claims',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClaimsScreen(),
                  ),
                );
              }),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemExtent: 85,
        itemBuilder: (context, index) {
          if (index == showntransactions.length && cupertinoCounter == 1) {
            return const CupertinoActivityIndicator();
          }
          return ListTile(
            title: Text(DateFormat.yMMMMd('en_US')
                .format(showntransactions[index].createdAt)),
            subtitle: Text(showntransactions[index].transactionType),
            trailing: Text(showntransactions[index].amount.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(
                      transactionId:
                          showntransactions[index].transactionId.toString(),
                      transactionCurrency: showntransactions[index].currency,
                      transactionType: showntransactions[index].transactionType,
                      transactionAmount: showntransactions[index].amount,
                      transactionDate: showntransactions[index].createdAt,
                      transactionDetails:
                          showntransactions[index].transactionPurpose,
                      recipientName: showntransactions[index].recipient.name,
                      recipientAccount:
                          showntransactions[index].recipient.accountNumber),
                ),
              );
            },
          );
        },
        itemCount: showntransactions.length + cupertinoCounter,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DonationPage()));
        },
        label: const Text('Donate'),
        icon: const Icon(Icons.diversity_3_outlined),
      ),
    );
  }
}
