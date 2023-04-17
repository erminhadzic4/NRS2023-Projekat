import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:nrs2023/screens/filters.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class Transaction {
  late DateTime date;
  late String type;
  late double amount;
  late String id;
  late String currency;
  late String details;
  late String recipientName;
  late String recipientAcc;
  late String providerName;

  // constructor
  Transaction(this.id, this.amount, this.currency, this.type, this.details,
      this.date, this.recipientName, this.recipientAcc, this.providerName);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['transactionId'].toString(),
      json['amount'].toDouble(),
      json['currency'],
      json['paymentType'],
      json['description'],
      DateTime.parse(json['createdAt']),
      json['recipientName'],
      json['recipientAccountNumber'].toString(),
      json['providerName'],
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
  late bool? filterDepositsTrue;
  late bool? filterWithdrawalsTrue;

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
      required this.filterCategory});
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<Transactions> {
  var token;
  final transactions = <Transaction>[];
  final showntransactions = <Transaction>[];
  ScrollController _scrollController = ScrollController();
  int shownTransactionsLimit = 10;
  int _currentPage = 1;
  int _loadTransactionsLimit = 10;
  bool _isLoading = false;
  String searchValue = '';
  int shownTransactionsCounter = 0;
  int cupertinoCounter = 1;
  int _sortOption = 0;
  // 1 znaci ON, 0 znaci OFF

//KOD Za povlacenje tranzakcija sa API-a

  @override
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    _getMoreTransactions();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
        _getMoreTransactions();
      }
    });
    _sorting();
  }

  //KOD za ucitavanje novih transakcija u prikaz
  _getMoreList() {
    shownTransactionsLimit = shownTransactionsLimit + 10;
    _sorting();
    setState(() {});
  }

//KOD za podatke sa servera
  Future<void> _getMoreTransactions() async {
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
    var sortingOrder; // TREBA IMPLEMENTIRATI
    var link =
        "https://processingserver.herokuapp.com/Transaction/GetTransactionsForUser?token=$token&pageNumber=$_currentPage&pageSize=$_loadTransactionsLimit&AmountStartFilter=$startAmount&AmountEndFilter=$endAmount&CurrencyFilter=$currency&RecipientNameFilter=$recipientName&RecipientAccountNumberFilter=$recipientAccountNumber&SenderNameFilter=$senderName&CreatedAtStartFilter=$dateStart&CreatedAtEndFilter=$dateEnd&CategoryFilter=$category";
    if (currency != "All") {
      link = link + "&CurrencyFilter=$currency";
    }
    final url = Uri.parse(link);
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    responseData.forEach((transactionData) {
      showntransactions.add(Transaction.fromJson(transactionData));
      transactions.add(Transaction.fromJson(transactionData));
    });
    setState(() {
      _isLoading = false;
      _currentPage++;
    });
  }

//Sortiranje // Ovo treba implementirati preko API
  Future<void> _sorting() async {
    if (_sortOption == 0) {
      showntransactions.sort((a, b) => a.date.compareTo(b.date));
    } else if (_sortOption == 1) {
      showntransactions.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortOption == 2) {
      showntransactions.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (_sortOption == 3) {
      showntransactions.sort((a, b) => b.amount.compareTo(a.amount));
    }
    setState(() {});
  }

//KOD za podatke sa servera
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: FittedBox(
          child: Text("All Transactions"),
        ),
        onSearch: (value) => setState(() {
          //_filtering();
          searchValue = value;
          for (int i = 0; i < transactions.length; i++) {
            if (transactions[i].details.contains(searchValue) == false) {
              showntransactions.remove(transactions[i]);
            }
          }
        }),
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
                          setState(() {
                            _sortOption = 2;
                            _sorting();
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Amount (descending)"),
                        onTap: () {
                          // Sort transactions by amount (descending)
                          setState(() {
                            _sortOption = 3;
                            _sorting();
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (ascending)"),
                        onTap: () {
                          // Sort transactions by date (ascending)
                          setState(() {
                            _sortOption = 0;
                            _sorting();
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (descending)"),
                        onTap: () {
                          // Sort transactions by date (descending)
                          setState(() {
                            _sortOption = 1;
                            _sorting();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.grid_on_rounded),
            onPressed: () {
              print("group");
            },
          )
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
                .format(showntransactions[index].date)),
            subtitle: Text(showntransactions[index].type),
            trailing: Text(showntransactions[index].amount.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(
                      transactionId: showntransactions[index].id,
                      transactionCurrency: showntransactions[index].currency,
                      transactionType: showntransactions[index].type,
                      transactionAmount: showntransactions[index].amount,
                      transactionDate: showntransactions[index].date,
                      transactionDetails: showntransactions[index].details,
                      recipientName: showntransactions[index].recipientName,
                      recipientAccount: showntransactions[index].recipientAcc),
                ),
              );
            },
          );
        },
        itemCount: showntransactions.length + cupertinoCounter,
      ),
    );
  }
}
