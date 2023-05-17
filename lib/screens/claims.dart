import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import 'dart:convert';
import 'package:nrs2023/screens/claimdetails.dart';

// Klasa Claim
class Claim {
  String id;
  String trancastionid;
  String subject;
  String description;
  String status;
  DateTime created;

  Claim(
    this.id,
    this.trancastionid,
    this.subject,
    this.description,
    this.status,
    this.created,
  );

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
        json['id'].toString(),
        json['trancastionid'].toString(),
        json['subject'],
        json['description'],
        json['status'],
        DateTime.parse(json['created']));
  }
}

class ClaimsScreen extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<ClaimsScreen> {
  var Claims = <Claim>[];
  Future<void> _getClaims() async {
    var link =
        "http://siprojekat.duckdns.org:5051/api/transactions/user/claims";
    final url = Uri.parse(link);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    final responseData = json.decode(response.body);
    responseData.forEach((claimData) {
      Claims.add(Claim.fromJson(claimData));
    });
    setState(() {});
  }

  var token;
  @override
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    _getClaims();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Claims'),
      ),
      body: ListView.builder(
        itemExtent: 85,
        itemBuilder: (context, index) {
          if (Claims[index].status == "Under_Investigation")
            Claims[index].status = "Open";
          return ListTile(
            title: Text(Claims[index].subject),
            subtitle: Text("Status: " + Claims[index].status),
            trailing:
                Text(DateFormat.yMMMMd('en_US').format(Claims[index].created)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClaimDetailsScreen(
                      id: Claims[index].id,
                      transactionid: Claims[index].trancastionid,
                      subject: Claims[index].subject,
                      description: Claims[index].description,
                      dateTime: Claims[index].created,
                      status: Claims[index].status),
                ),
              );
            },
          );
        },
        itemCount: Claims.length,
      ),
    );
  }
}
