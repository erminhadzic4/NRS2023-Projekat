import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart' as intl;
import 'package:nrs2023/screens/claimdetails.dart';

// Klasa Claim
class Claim {
  String subject;
  String description;
  DateTime dateTime;

  Claim(
    this.subject,
    this.description,
    this.dateTime,
  );

  /* TREBA IMPLEMENTATI
  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
        json['subject'], json['description'], json['file'], json['dateTime']);
  }
  */
}

class ClaimsScreen extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<ClaimsScreen> {
  var Claims = <Claim>[
    Claim("This is a claim", "This is the description of this claim",
        DateTime.now()),
    Claim("This is a claim #2", "This is the description of this claim #2",
        DateTime.now())
  ];
  /* TREBA IMPLEMENTATI
  Future<void> _getClaims() async {
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
  */

  @override
  void initState() {
    // _getClaims();
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
          return ListTile(
            title: Text(Claims[index].subject),
            subtitle: Text("Description " + Claims[index].description),
            trailing: Text("Date " +
                intl.DateFormat.yMMMMd('en_US').format(Claims[index].dateTime)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClaimDetailsScreen(
                      subject: Claims[index].subject,
                      description: Claims[index].description,
                      dateTime: Claims[index].dateTime),
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
