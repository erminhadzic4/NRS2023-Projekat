import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:http/http.dart' as http;

class NumberValidation extends StatefulWidget {
  const NumberValidation({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<NumberValidation> createState() => _NumberValidationState();
}

class _NumberValidationState extends State<NumberValidation> {
  final TextEditingController _phoneController = TextEditingController();
  String _confirmationCode = '';
  bool logged = false;
  bool codeSent = false;

  void _onCodeChanged(String value) {
    setState(() {
      _confirmationCode = value;
    });
  }

  void _onSendCodePressed() {
    //sendCode(userName);
  }

  void _onConfirmPressed() {
    String correctCode = '123456';
  }

  void makeDialog(http.Response res) {
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Your phone number has been confirmed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  logged = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failure'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'The confirmation code is incorrect.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.username;
    void Print() {
      print(userName + _confirmationCode);
    }

    Future<void> verifyNumber() async {
      final url = Uri.parse(
          'http://siprojekat.duckdns.org:5051/api/User/confirm/phone');
      final headers = {'Content-Type': 'application/json'};
      final body =
          json.encode({'Username': userName, 'code': _confirmationCode});

      print(userName + " " + _confirmationCode);

      final res = await http.post(url, headers: headers, body: body);

      if (res.statusCode == 200) {
        print('Request sent successfully');
        makeDialog(res);
      } else {
        makeDialog(res);
        print('Request failed with status: ${res.statusCode}.');
      }
    }

    void sendCode(String username) async {
      final url = await http.get(
          Uri.parse(
              "http://siprojekat.duckdns.org:5051/api/User/send/sms?Username=$username"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (url.statusCode == 200) {
        setState(() {
          codeSent = true;
        });
      } else {
        codeSent = false;
      }
    }

    InputDecoration registerInputDecoration(String labelText, String hintText) {
      return InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Verify number"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: SizedBox(
                  width: 350,
                  child: Text("Confirm phone number",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 33,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 350,
                  child: Text(
                      'Click on "Send code" button to get your code via SMS!',
                      // + myController.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black87, fontSize: 18)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onChanged: (value) {
                            _onCodeChanged(value);
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              registerInputDecoration("Pin", "Enter Pin"),
                          onFieldSubmitted: (String value) {},
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 4 ||
                                value.contains(RegExp(r'[A-Za-z]'))) {
                              return 'Invalid pin';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              elevation: 10,
                              height: 50,
                              minWidth: 120,
                              onPressed: () {
                                if (codeSent) {
                                  verifyNumber();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Failure'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 64,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'The code has not been sent yet!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              color: Colors.blue,
                              child: const Text("Verify",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              elevation: 10,
                              height: 50,
                              minWidth: 120,
                              onPressed: () {
                                Print();
                                sendCode(userName);
                              },
                              color: Colors.blue,
                              child: const Text("Send code",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
