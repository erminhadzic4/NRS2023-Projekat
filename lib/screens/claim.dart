import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Claim {
  String subject;
  String description;
  File file;
  DateTime dateTime;
  String status;

  Claim(
    this.subject,
    this.description,
    this.file,
    this.dateTime,
    this.status,
  );

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       json['transactionId'],
//       json['amount'].toDouble(),
//       json['currency'],
//       json['transactionType'],
//       json['transactionPurpose'],
//       json['category'],
//       DateTime.parse(json['createdAt']),
//       json['recipientId'],
//       User.fromJson(json['recipient']),
//       json['senderId'],
//       User.fromJson(json['sender']),
//     );
//   }
}

class ClaimPage extends StatefulWidget {
  @override
  _ClaimPageState createState() => _ClaimPageState();
}

String path = "";
String status = "Open";

class _ClaimPageState extends State<ClaimPage> {
  TextEditingController _problemTypeController = TextEditingController();
  TextEditingController _problemDescriptionController = TextEditingController();

  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      PlatformFile file = resultFile.files.first;
      setState(() {
        path = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: status == 'Open',
              //visible: claim.status == 'open',
              child: Container(
                width: 400,
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Status: $status',
                  //'Status: ${claim.status}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _problemTypeController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _problemDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            Center(child: AutoSizeText(path)),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    openFiles();
                  },
                  child: Text("Upload file")),
            ),
            SizedBox(
              width: 12,
            ),
            Center(
                child: ElevatedButton(onPressed: () {}, child: Text("Submit")))
          ],
        ),
      ),
    );
  }
}
