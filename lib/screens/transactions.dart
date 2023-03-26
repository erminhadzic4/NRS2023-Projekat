import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  late String date;
  late String type;
  late double amount;
  late String id;
  late String currency;
  late String details;

  // constructor
  Transaction(
      this.date, this.type, this.amount, this.currency, this.details, this.id);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['date'],
      json['type'],
      json['amount'].toDouble(),
      json['id'],
      json['currency'],
      json['details'],
    );
  }
}

class Transactions extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}


class InitalState extends State<Transactions> {
  late List<Transaction> transactions;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  int _currentPage = 1;
  bool _isLoading = false;

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
  @override
  void initState() {
    //TODO: implement initState from Backend
    super.initState();
    transactions = List.generate(
      10,
      (index) => Transaction('Jan ${index + 1} 2021', 'Deposit',
          100.0 + (index * 10), 'EUR', 'detail', '12345'),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
  }

  _getMoreList() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      transactions.add(Transaction('Jan ${i + 1} 2021', 'Deposit',
          100.0 + (i * 10), 'EUR', 'detail', '12345'));
    }
    _currentMax = _currentMax + 10;
    setState(() {});
  }
//KOD za dummy podatke


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
//KOD za podatke sa servera


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemExtent: 85,
        itemBuilder: (context, index) {
          if (index == transactions.length) {
            return const CupertinoActivityIndicator();
          }
          return ListTile(
            title: Text(transactions[index].date),
            subtitle: Text(transactions[index].type),
            trailing: Text(transactions[index].amount.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(
                      transactionId: transactions[index].id,
                      transactionCurrency: transactions[index].currency,
                      transactionType: transactions[index].type,
                      transactionAmount: transactions[index].amount,
                      transactionDate: transactions[index].date,
                      transactionDetails: transactions[index].details),
                ),
              );
            },
          );
        },
        itemCount: transactions.length + 1,
      ),
    );
  }
}
