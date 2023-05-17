import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import 'dart:convert';
import 'package:nrs2023/screens/donation.dart';
import 'package:nrs2023/screens/donationdetails.dart';
import 'package:nrs2023/screens/claimdetails.dart';

// Klasa Donation
class Donation {
  String id;
  String recipientName;
  String recipientAccount;
  String category;
  String currency;
  String amount;
  String frequency;
  String duration;
  String timetype;
  String details;
  DateTime created;

  Donation(
      this.id,
      this.recipientName,
      this.recipientAccount,
      this.category,
      this.currency,
      this.amount,
      this.frequency,
      this.duration,
      this.timetype,
      this.details,
      this.created);
}

class DonationsScreen extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<DonationsScreen> {
  var Donations = <Donation>[
    Donation(
        1.toString(),
        "Hastor Fondacije",
        "12345",
        "Long-term donation",
        "USD",
        "100",
        "Every week",
        3.toString(),
        "Week",
        "Ovo je donacija za mocnu Hastor Fondaciju (nije pranje novca)",
        DateTime.now()),
    Donation(
        1.toString(),
        "KC Korporacija",
        "54321",
        "One-time donation",
        "USD",
        "2000",
        "",
        "",
        "",
        "Ovo je donacija za novog sibirskog plavca",
        DateTime.now()),
  ];
  var token;
  @override
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Donations'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'New Donation',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DonationPage()));
          },
        )
      ]),
      body: ListView.builder(
        itemExtent: 85,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Donation for: " + Donations[index].recipientName),
            subtitle: Text("Amount: " +
                Donations[index].amount +
                " " +
                Donations[index].currency),
            trailing: Text(Donations[index].category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationDetailsScreen(
                      id: Donations[index].id,
                      recipientName: Donations[index].recipientName,
                      recipientAccount: Donations[index].recipientAccount,
                      category: Donations[index].category,
                      currency: Donations[index].currency,
                      amount: Donations[index].amount,
                      frequency: Donations[index].frequency,
                      duration: Donations[index].duration,
                      timetype: Donations[index].timetype,
                      details: Donations[index].details,
                      created: Donations[index].created),
                ),
              );
            },
          );
        },
        itemCount: Donations.length,
      ),
    );
  }
}
