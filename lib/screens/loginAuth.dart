import 'package:flutter/material.dart';
import 'package:nrs2023/screens/home.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({Key? key}) : super(key: key);

  @override
  LoginAuthScreenState createState() => LoginAuthScreenState();
}

class LoginAuthScreenState extends State<LoginAuthScreen> {
  late String emailCode;
  late String phoneCode;

  @override
  void initState() {
    super.initState();

    emailCode = "123456";
    phoneCode = "654321";
  }

  getEmailCode() {return emailCode;}

  getPhoneCode() {return phoneCode;}

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
                  emailCode = value;
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
                  phoneCode = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                // TODO: IMPLEMENTIRATI LOGIKU VALIDACIJE
                print('Email code entered: $emailCode');
                print('Phone code entered: $phoneCode');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
              ),
              child: const Text(
                  'Submit',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
