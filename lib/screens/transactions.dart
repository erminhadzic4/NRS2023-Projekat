import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

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
}

class _HomePageState extends State<HomePage> {
  late List dummyList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

/*
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    dummyList = List.generate(10, (index) => "Item : ${index + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
  }
  */

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    dummyList = List.generate(
      10,
      (index) => Transaction('Jan $index 2021', 'Deposit', 100.0 + (index * 10),
          'EUR', 'detail', '12345'),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
  }

  /*
  List<Transaction> transactions = [
    Transaction('Jan 1, 2021','Deposit',100.0),
    Transaction('Jan 2, 2021','Withdrawal',50.0),
    Transaction('Jan 3, 2021','Payment',25.0),
  ];
  */

  _getMoreList() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      dummyList.add(Transaction('Jan $i 2021', 'Deposit', 100.0 + (i * 10),
          'EUR', 'detail', '12345'));
    }
    _currentMax = _currentMax + 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemExtent: 80,
        itemBuilder: (context, index) {
          if (index == dummyList.length) {
            return const CupertinoActivityIndicator();
          }
          return ListTile(
            title: Text(dummyList[index].date),
            subtitle: Text(dummyList[index].type),
            trailing: Text(dummyList[index].amount.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(
                      transactionId: dummyList[index].id,
                      transactionCurrency: dummyList[index].currency,
                      transactionType: dummyList[index].type,
                      transactionAmount: dummyList[index].amount,
                      transactionDate: dummyList[index].date,
                      transactionDetails: dummyList[index].details),
                ),
              );
            },
          );
        },
        itemCount: dummyList.length + 1,
      ),
    );
  }
}
