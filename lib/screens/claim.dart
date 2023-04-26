import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Claim {
  String subject;
  String description;
  File file;
  DateTime dateTime;

  Claim(
    this.subject,
    this.description,
    this.file,
    this.dateTime,
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
