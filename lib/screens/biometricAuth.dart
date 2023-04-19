import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

import '../auth_provider.dart';
import 'loginAuth.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<BiometricAuthentication> createState() => BiometricAuthenticationState();
}

class BiometricAuthenticationState extends State<BiometricAuthentication> {
  late AuthProvider _authProvider;
  //Za dobivanje tokena na ostalim ekranima nakon uspješne prijave iskoristi ove dvije linije koda u initState svog ekrana:
  //  final _authProvider = Provider.of<AuthProvider>(context, listen: false);
  //  token = _authProvider.token;
  var token;
  var userId;
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
            (bool isSupported) => setState(() {
          _supportState = isSupported;
        })
    );
  }

  Future<void> getSupportedBios() async{
    List<BiometricType> avalibleBios = await auth.getAvailableBiometrics();
    print(avalibleBios);
    if(!mounted) {
      return;
    }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch(e) {
      print(e);
      return false;
    }
  }

  void logInRequest(String phoneEmail, String password) async {
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "myEmail",
          "password": "myPassword",
        }));
    if ( (res.statusCode == 200) && context.mounted) {
      var responseData = jsonDecode(res.body);
      _authProvider.setToken(responseData['token']);
      token = responseData['token'];
      userId = responseData['userId'];
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
                  'You will now be prompted for 2FA!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginAuthScreen()),
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
                  'Login failed!',
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



  Future<bool> authenticate() async {
    final isAvalible = await hasBiometrics();
    if(!isAvalible) {
      return false;
    }
    try {
      final authComplete = await auth.authenticate(
          localizedReason: "Authenticate yourself with either fingerprint or face recognition",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            useErrorDialogs: true,
          )
      );
      if(authComplete == true) {
        //print("moze");

        return true;
      }
      else {
        print("ne moze");
        return false;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometrics Login"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0),
                    child: const Text(
                      "Authenticate using your fingerprint or face recognition",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey,
                          height: 1.5, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: authenticate,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text("Authenticate", style: TextStyle(color: Colors.white,
                          fontSize: 25.0, ),
                        )
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 80), // prazan prostor za podizanje dugmeta
          ],
        ),
      ),
    );
  }
}

