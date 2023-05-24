import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nrs2023/screens/logInPhone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'package:nrs2023/screens/welcome.dart';
import 'package:provider/provider.dart';
import '../api/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:local_auth/local_auth.dart';
import '../auth_provider.dart';
import 'home.dart';
import 'loginAuth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class logIn extends StatefulWidget {
  const logIn({Key? key}) : super(key: key);

  @override
  State<logIn> createState() => _logInState();

  Future<void> logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    //final token = await storage.read(key: 'token');
    String? token = await storage.read(key: 'token');
    final url = Uri.parse("http://siprojekat.duckdns.org:5051/api/User/logout");

    try {
      final response = await http.patch(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

      // headers: {'Authorization': 'Bearer $token'},
      // );
      if (response.statusCode == 200) {
        await storage.delete(key: 'token');
        Navigator.pushAndRemoveUntil<Widget>(
          context,
          MaterialPageRoute<Widget>(builder: (context) => WelcomeScreen()),
          (route) => false,
        );
      } else {
        throw Exception('Failed to log out');
      }
    } catch (e) {
      print('Error occurred while logging out: $e');
    }
  }
}

bool _isLoggedIn = false;
Map _userObj = {};

class _logInState extends State<logIn> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthProvider _authProvider;

  //Za dobivanje tokena na ostalim ekranima nakon uspješne prijave iskoristi ove dvije linije koda u initState svog ekrana:
  // final _authProvider = Provider.of<AuthProvider>(context, listen: false);
  //  token = _authProvider.token;
  var token;
  var userId;

  late final LocalAuthentication auth;
  bool _supportState = false;
  final bioStorage = FlutterSecureStorage();
  bool _useBios = false;
  late var bioMail = "";
  late var bioPassword = "";

  @override
  void initState() {
    configOneSignal();
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  void configOneSignal() async {
    await OneSignal.shared.setAppId("fea9b7bf-2d17-401e-8026-78e184289a62");
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      OSNotificationDisplayType.notification;
    });
  }

  void sendNotification() async {
    await http.post(Uri.parse("https://onesignal.com/api/v1/notifications"),
        headers: <String, String>{
          'Authorization':
              'Basic OGJhZmVkMTMtMDc0Ni00ZjdlLTg3MDctMTFiMGU4NTExMTRh',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "app_id": "fea9b7bf-2d17-401e-8026-78e184289a62",
          "included_segments": ["Subscribed Users"],
          "data": {"foo": "bar"},
          "contents": {"en": "Sample Notification"}
        }));
  }

  void logInRequest(String phoneEmail, String password) async {
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": _emailController.text,
          "password": _passwordController.text,
        }));
    if ((res.statusCode == 200) && context.mounted) {
      if (_useBios) {
        bioStorage.write(key: "email", value: _emailController.text);
        bioStorage.write(key: "password", value: _passwordController.text);
      }
      var responseData = jsonDecode(res.body);
      _authProvider.setToken(responseData['token']);
      token = responseData['token'];
      userId = responseData['userId'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: '$token');

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
                  'Welcome Back!',
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

  Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  void getBioStorage() async {
    final email = await bioStorage.read(key: "email");
    //print(email);
    setState(() {
      bioMail = email!;
    });
    final password = await bioStorage.read(key: "password");
    //print(password);
    setState(() {
      bioPassword = password!;
    });
  }

  void bioLogInRequest() async {
    getBioStorage();
    //print(bioMail + bioPassword);
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": bioMail,
          "password": bioPassword,
        }));
    if ((res.statusCode == 200) && context.mounted) {
      var responseData = jsonDecode(res.body);
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
                  'Welcome Back!',
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
    if (!isAvalible) {
      return false;
    }
    try {
      final authComplete = await auth.authenticate(
          localizedReason:
              "Authenticate yourself with either fingerprint or face recognition",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            useErrorDialogs: true,
          ));
      if (authComplete == true) {
        //print("moze");
        bioLogInRequest();
        return true;
      } else {
        print("ne moze");
        return false;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onLongPress: sendNotification,
            child: Text("Login"),
          ),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          key: const ValueKey('Container'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: SizedBox(
                  width: 350,
                  child: Text("Login",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 33,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 350,
                  child: Text('E-mail',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        key: const ValueKey('EmailField'),
                        //controller: _controllers[0],
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            registerInputDecoration("Email", "Enter Email"),
                        onFieldSubmitted: (String value) {
                          //FocusScope.of(context).requestFocus(_focusInput[0]);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains("@")) {
                            return 'Invalid address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 350,
                  child: Text('Password',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          key: const ValueKey('PasswordField'),
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: registerInputDecoration(
                              "Password", "Enter password"),
                          onFieldSubmitted: (String value) {
                            //FocusScope.of(context).requestFocus(_focusInput[0]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //validator:
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 350,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const logInPhone()),
                      );
                    },
                    child: const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                        'Login via phone number'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: MaterialButton(
                  key: const ValueKey('loginbutton'),
                  elevation: 10,
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    logInRequest(
                        _emailController.text, _passwordController.text);
                    print(
                        _emailController.text + " " + _passwordController.text);
                  },
                  color: Colors.blue,
                  child: const Text("LOGIN",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    SignInButton(
                      Buttons.Google,
                      //mini: true,
                      onPressed: () async {
                        await GoogleSignInApi.signOut;
                        await GoogleSignInApi.login();
                        //_handleSignIn;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () async {
                        /* await _handleSignOut();
                                await _handleSignIn;*/
                        await FacebookAuth.instance.logOut().then((value) {
                          setState(() {
                            _isLoggedIn = false;
                            _userObj = {};
                          });
                        });
                        await FacebookAuth.instance.login(permissions: [
                          "public_profile",
                          "email"
                        ]).then((value) {
                          FacebookAuth.instance
                              .getUserData()
                              .then((userData) async {
                            setState(() {
                              _isLoggedIn = true;
                              _userObj = userData;
                            });
                          });
                        });
                        //if(_isLoggedIn){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                        //}
                      },
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.fingerprint,
                      size: 30.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Biometric login',
                      style: TextStyle(
                        //backgroundColor: Colors.blue,
                        fontSize: 20,
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Checkbox(
                    value: _useBios,
                    onChanged: (newValue) {
                      setState(() {
                        _useBios = newValue!;
                      });
                    }),
                SizedBox(
                  height: 10,
                ),
                Text("Use Biometric ID")
              ])
            ],
          ),
        ),
      ),
    );
  }
}
