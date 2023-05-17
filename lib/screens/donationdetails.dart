import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class DonationDetailsScreen extends StatefulWidget {
  late String id;
  late String recipientName;
  late String recipientAccount;
  late String category;
  late String currency;
  late String amount;
  late String frequency;
  late String duration;
  late String timetype;
  late String details;
  late DateTime created;
  DonationDetailsScreen({
    required this.id,
    required this.recipientName,
    required this.recipientAccount,
    required this.category,
    required this.currency,
    required this.amount,
    required this.frequency,
    required this.duration,
    required this.timetype,
    required this.details,
    required this.created,
  });
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<DonationDetailsScreen> {
  DateTime? _nextDate() {
    print(widget.category);
    if (widget.frequency == "Every day") {
      return (widget.created.add(const Duration(days: 1)));
    } else if (widget.frequency == "Every week") {
      return (widget.created.add(const Duration(days: 7)));
    } else if (widget.frequency == "Every month") {
      return (widget.created.add(const Duration(days: 30)));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Donation Details'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Recipient: " + widget.recipientName,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Recipient's account: " + widget.recipientAccount,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Category: " + widget.category,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Amount: " + widget.amount + " " + widget.currency,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Date: " +
                            DateFormat.yMMMMd('en_US').format(widget.created),
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Donation details: " + widget.details,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      if (_nextDate() != null)
                        Text(
                          "Next donation date: " +
                              DateFormat.yMMMMd('en_US').format(_nextDate()!),
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                    ]))));
  }
}
