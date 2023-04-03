import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:nrs2023/screens/filters.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Transaction {
  late DateTime date;
  late String type;
  late double amount;
  late String id;
  late String currency;
  late String details;
  late String recipientN;
  late String recipientAcc;

  // constructor
  Transaction(this.date, this.type, this.amount, this.currency, this.details,
      this.id, this.recipientN, this.recipientAcc);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['date'],
      json['type'],
      json['amount'].toDouble(),
      json['id'],
      json['currency'],
      json['details'],
      json['recipientN'],
      json['recipientAcc'],
    );
  }
}

class Transactions extends StatefulWidget {
  late DateTime filterDateStart;
  late DateTime filterDateEnd;
  late String filterCurrency;
  late double filterPriceRangeStart;
  late double filterPriceRangeEnd;
  late bool? filterDepositsTrue;
  late bool? filterWithdrawalsTrue;

  Transactions({
    required this.filterDateStart,
    required this.filterDateEnd,
    required this.filterCurrency,
    required this.filterPriceRangeStart,
    required this.filterPriceRangeEnd,
    required this.filterDepositsTrue,
    required this.filterWithdrawalsTrue,
  });
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<Transactions> {
  final transactions = <Transaction>[];
  final showntransactions = <Transaction>[];
  ScrollController _scrollController = ScrollController();
  int shownTransactionsLimit = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  String searchValue = '';
  int shownTransactionsCounter = 0;
  int cupertinoCounter = 1; // 1 znaci ON, 0 znaci OFF

//KOD Za povlacenje tranzakcija sa API-a

/*
  @override
  void initState() {
    super.initState();
    transactions = [];
    _getMoreTransactions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreTransactions();
      }
    });
  }
*/

//KOD za dummy podatke
  void initState() {
    // Mock baza sa 10000 transakcija
    for (int i = 0; i < 10000; i++) {
      final insertDate = DateTime(2020, 1, i + 1); // Datum raste za jedan dan
      var insertCurrency; // Valuta - Moze biti EUR USD GBP ili CHF
      var insertType; // Tip Transakcije - Moze biti Deposit ili Withdrawal
      final insertAmount = (i + 1) * 10.0; // Iznos raste za 100
      final insertId = i.toString(); // Id Transakcije raste za 1
      var inesertRecipientN; // Ime primatelja, rotira 4 imena
      var inesertRecipientAcc; // Racun primatelja, rotira 4 racuna
      var insertDetails; // Detalji, rotira 4 detalja
      if (i % 4 == 0) {
        insertCurrency = 'EUR';
        insertType = 'Withdrawal';
        inesertRecipientN = 'Enes';
        inesertRecipientAcc = '384324924923';
        insertDetails = '$insertType for school';
      }
      if (i % 4 == 1) {
        insertCurrency = 'USD';
        insertType = 'Deposit';
        inesertRecipientN = 'Amir';
        inesertRecipientAcc = '884567324895';
        insertDetails = '$insertType for taxes';
      }
      if (i % 4 == 2) {
        insertCurrency = 'GBP';
        insertType = 'Withdrawal';
        inesertRecipientN = 'Nikola';
        inesertRecipientAcc = '439682436329';
        insertDetails = '$insertType for amazon';
      }
      if (i % 4 == 3) {
        insertCurrency = 'CHF';
        insertType = 'Deposit';
        inesertRecipientN = 'Edin';
        inesertRecipientAcc = '970456340532';
        insertDetails = '$insertType for video games';
      }
      transactions.add(Transaction(
          insertDate,
          insertType,
          insertAmount,
          insertCurrency,
          insertDetails,
          insertId,
          inesertRecipientN,
          inesertRecipientAcc));
    }
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
    for (int i = 0; i < transactions.length; i++) {
      showntransactions.add(transactions[i]);
    }
    _filtering();
  }

  //KOD za ucitavanje novih transakcija u prikaz
  _getMoreList() {
    shownTransactionsLimit = shownTransactionsLimit + 10;
    _filtering();
    setState(() {});
  }

//KOD za podatke sa servera
  Future<void> _getMoreTransactions() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    //URL ce se promijeniti kada RI završti backend
    final url = Uri.parse('https://my-api.com/transactions?page=$_currentPage');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final List<Transaction> loadedTransactions = [];
    responseData['data'].forEach((transactionData) {
      loadedTransactions.add(Transaction.fromJson(transactionData));
    });
    setState(() {
      transactions.addAll(loadedTransactions);
      _isLoading = false;
      _currentPage++;
    });
  }

  //Filtriranje
  Future<void> _filtering() async {
    showntransactions.clear();
    int i;
    for (i = 0; i < transactions.length; i++) {
      if (widget.filterWithdrawalsTrue == false &&
          transactions[i].type == 'Withdrawal') {
        continue;
      }
      if (widget.filterDepositsTrue == false &&
          transactions[i].type == 'Deposit') {
        continue;
      }
      if (transactions[i].amount < widget.filterPriceRangeStart ||
          transactions[i].amount > widget.filterPriceRangeEnd) {
        continue;
      }
      if (transactions[i].currency != widget.filterCurrency &&
          widget.filterCurrency != 'All') {
        continue;
      }
      if (transactions[i].date.isBefore(widget.filterDateStart) == true ||
          transactions[i].date.isAfter(widget.filterDateEnd) == true) {
        continue;
      }
      if (transactions[i].details.contains(searchValue)) {
        showntransactions.add(transactions[i]);
        if (shownTransactionsLimit == showntransactions.length) {
          break;
        }
      }
    }
    if (i == transactions.length) {
      cupertinoCounter = 0;
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
          _filtering();
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
                              isCheckedDeposit: widget.filterDepositsTrue,
                              isCheckedWithdrawal: widget.filterWithdrawalsTrue,
                              textEditingController1: TextEditingController(
                                  text: widget.filterPriceRangeStart
                                      .toInt()
                                      .toString()),
                              textEditingController2: TextEditingController(
                                  text: widget.filterPriceRangeEnd
                                      .toInt()
                                      .toString()),
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
                            showntransactions
                                .sort((a, b) => a.amount.compareTo(b.amount));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Amount (descending)"),
                        onTap: () {
                          // Sort transactions by amount (descending)
                          setState(() {
                            showntransactions
                                .sort((a, b) => b.amount.compareTo(a.amount));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (ascending)"),
                        onTap: () {
                          // Sort transactions by date (ascending)
                          setState(() {
                            showntransactions
                                .sort((a, b) => a.date.compareTo(b.date));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (descending)"),
                        onTap: () {
                          // Sort transactions by date (descending)
                          setState(() {
                            showntransactions
                                .sort((a, b) => b.date.compareTo(a.date));
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
                      recipientName: showntransactions[index].recipientN,
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
