import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final String title;
  final String description;
  final double amount;

  Transaction(
      {required this.title, required this.description, required this.amount});
}

class _HomePageState extends State<HomePage> {
  late List transactions;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    transactions = List.generate(
      10,
      (index) => Transaction(
          title: 'Transaction ${index + 1}',
          description: 'Description ${index + 1}',
          amount: 10.0 * (index + 1)),
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
      transactions.add(Transaction(
          title: 'Transaction ${i + 1}',
          description: 'Description ${i + 1}',
          amount: 10.0 * (i + 1)));
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
          if (index == transactions.length) {
            return const CupertinoActivityIndicator();
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailsScreen(transaction: transactions[index]),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(transactions[index].title),
                subtitle: Text(transactions[index].description),
                trailing: Text('${transactions[index].amount}'),
              ),
            ),
          );
        },
        itemCount: transactions.length + 1,
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Transaction transaction;

  DetailsScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(transaction.description),
            SizedBox(height: 16.0),
            Text('Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${transaction.amount}'),
          ],
        ),
      ),
    );
  }
}
