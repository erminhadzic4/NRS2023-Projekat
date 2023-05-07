import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

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
}

Future<http.Response> createClaim(int transactionId, String subject,
    String description, List<int> documentIds) {
  return http.post(
    Uri.parse("http://siprojekat.duckdns.org:5051/api/transactions/claim"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({
      'transactionId': transactionId,
      'subject': subject,
      'description': description,
      'documentIds': documentIds
    }),
  );
}

class ClaimPage extends StatefulWidget {
  late int transactionId;
  ClaimPage({required this.transactionId});
  @override
  _ClaimPageState createState() => _ClaimPageState();
}

String path = "";
String message = "";
var token;

class _ClaimPageState extends State<ClaimPage> {
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
  }

  TextEditingController _problemTypeController = TextEditingController();
  TextEditingController _problemDescriptionController = TextEditingController();
  void PostClaim() async {
    http.Response response = await createClaim(
        widget.transactionId,
        _problemTypeController.text,
        _problemDescriptionController.text,
        <int>[16]);
    print(response.body);
  }

  late String? path;
  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      path = resultFile.files.single.path;
      setState(() {});
      uploadFiles();
    }
  }

  void uploadFiles() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://siprojekat.duckdns.org:5051/api/Document/UploadDocument'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(await http.MultipartFile.fromPath('file', '$path'));
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    if (response.statusCode == 200) {
      print('Success');
      print(responseData);
    } else
      print('Error');
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
                child: ElevatedButton(
                    onPressed: () {
                      PostClaim();
                      message = 'Claim created succesfully';
                      setState(() {});
                    },
                    child: Text("Submit"))),
            Center(child: AutoSizeText(message)),
          ],
        ),
      ),
    );
  }
}
