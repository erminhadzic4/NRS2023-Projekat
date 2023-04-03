import 'package:flutter/material.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  _LoginAuthScreenState createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  late String _emailCode;
  late String _phoneCode;

  @override
  void initState() {
    super.initState();

    _emailCode = "123456";
    _phoneCode = "654321";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Authentication'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'A code has been sent to your email and phone number',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter code sent to email',
              ),
              onChanged: (value) {
                setState(() {
                  _emailCode = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter code sent to phone",
              ),
              onChanged: (value) {
                setState(() {
                  _phoneCode = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: IMPLEMENTIRATI LOGIKU VALIDACIJE
                print('Email code entered: $_emailCode');
                print('Phone code entered: $_phoneCode');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
