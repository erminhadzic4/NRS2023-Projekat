import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class Message {
  String messageContent;
  String messageType;

  Message(
    this.messageContent,
    this.messageType,
  );
}

class Claim {
  List<dynamic> messages;
  Claim(this.messages);
  factory Claim.fromJson(dynamic json) {
    return Claim(json['messages']);
  }
}

class ClaimDetailsScreen extends StatefulWidget {
  late String id;
  late String transactionid;
  late String subject;
  late String description;
  late DateTime dateTime;
  late String status;
  ClaimDetailsScreen(
      {required this.id,
      required this.transactionid,
      required this.subject,
      required this.description,
      required this.dateTime,
      required this.status});
  @override
  InitalState createState() => InitalState();
}

var token;

class InitalState extends State<ClaimDetailsScreen> {
  var Messages = <Message>[];
  late Claim claim;
  Future<void> _getMessages() async {
    var link = "http://siprojekat.duckdns.org:5051/api/transactions/claim/" +
        widget.id;
    final url = Uri.parse(link);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    final responseData = json.decode(response.body);
    Claim claim = Claim.fromJson(responseData);
    for (int i = 0; i < claim.messages.length; i++) {
      if (claim.messages[i]['userName'] != 'ABRULIC1') {
        // TREBALO BI BITI ADMIN USER ALI OVAJ ADMIN TOKEN STO IMAM JE OD ARBULIC1
        var newmessage = Message(claim.messages[i]['message'], 'sender');
        Messages.add(newmessage);
      } else {
        var newmessage = Message(claim.messages[i]['message'], 'receiver');
        Messages.add(newmessage);
      }
    }
    setState(() {});
  }

  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    _getMessages();
    super.initState();
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

  TextEditingController messageController = TextEditingController();
  void createMessage() async {
    http.Response response = await postMessage(
        int.parse(widget.id), messageController.text, <int>[16]);
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print('Error');
    }
    setState(() {
      messageController.text = '';
    });
    Messages.clear();
    _getMessages();
  }

  Future<http.Response> postMessage(
      int transactionClaimId, String message, List<int> documentIds) {
    return http.post(
      Uri.parse(
          "http://siprojekat.duckdns.org:5051/api/transactions/claim/message"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'transactionClaimId': transactionClaimId,
        'message': message,
        'documentIds': documentIds
      }),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Claim Details'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (widget.status == "Under_Investigation")
                        Text("Status: " + "Open".toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      else
                        Text("Status: " + widget.status.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.0),
                      Text("Subject: " + widget.subject),
                      SizedBox(height: 16.0),
                      Text("Description: " + widget.description),
                      SizedBox(height: 16.0),
                      ListView.builder(
                        itemCount: Messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment:
                                  (Messages[index].messageType == "receiver"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      (Messages[index].messageType == "receiver"
                                          ? Colors.grey.shade200
                                          : Colors.blue[200]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  Messages[index].messageContent,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, top: 10),
                          height: 60,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  openFiles();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  key: const ValueKey('messageField'),
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                key: const ValueKey('sendMessage'),
                                onPressed: () {
                                  createMessage();
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                backgroundColor: Colors.blue,
                                elevation: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]))));
  }
}
