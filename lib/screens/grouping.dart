import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Klasa Group
class Group {
  String keyValue;
  int totalAmount;
  int numberOfTransactions;

  Group(this.keyValue, this.totalAmount, this.numberOfTransactions);

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        json['keyValue'], json['totalAmount'], json['numberOfTransactions']);
  }
}

class GroupingScreen extends StatefulWidget {
  late String link;
  GroupingScreen({required this.link});
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<GroupingScreen> {
  var Groups = <Group>[];

  Future<void> _getGroups() async {
    final url = Uri.parse(widget.link);
    final response = await http.get(url);
    var counter = 0;
    final responseData = json.decode(response.body);
    responseData.forEach((groupData) {
      counter++;
      Groups.add(Group.fromJson(groupData));
    });
    setState(() {});
  }

  @override
  void initState() {
    _getGroups();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grouping'),
      ),
      body: ListView.builder(
        itemExtent: 85,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(Groups[index].keyValue),
            subtitle:
                Text("Total Amount: " + Groups[index].totalAmount.toString()),
            trailing: Text("Number of Transactions: " +
                Groups[index].numberOfTransactions.toString()),
          );
        },
        itemCount: Groups.length,
      ),
    );
  }
}
