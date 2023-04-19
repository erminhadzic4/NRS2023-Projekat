import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:nrs2023/screens/emailVaildation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../api/google_sign_in.dart';


String prettyPrint(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text.replaceAll('-', '');
    String formattedValue = '';
    for (int i = 0; i < value.length; i++) {
      formattedValue += value[i];
      if ((i + 1) % 4 == 0 && i != value.length - 1) {
        formattedValue += '-';
      }
    }
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
bool _isLoggedIn = false;
Map _userObj = {};
bool nextScreen = false;

class _RegisterState extends State<Register> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  /*GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );*/
  @override
  void initState() {
    super.initState();
   /* _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        // user signed in
        print('User signed in: ${account.email}');
        setState(() {
          _isLoggedIn = true;
        });
      }
      _googleSignIn.signInSilently();
    });*/
  }
/*
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
      setState(() {
        _isLoggedIn = false;
      });
    } catch (error) {
      print('Error signing out: $error');
    }
  }*/

  final List _focusInput = List.generate(9, (index) => FocusNode());
  final _formkey = GlobalKey<FormState>();

  final List _controllers =
  List.generate(9, (index) => TextEditingController());
  final myController = TextEditingController();

  void registerNewUser(String firstName,
      String lastName,
      String email,
      String username,
      String password,
      String address,
      String phoneNumber,
      String accountNumber) async {
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "username": username,
          "password": password,
          "address": address,
          "phoneNumber": phoneNumber,
          "accountNumber": accountNumber
        }));
    if (res.statusCode == 200 && context.mounted) {
      Navigator.push(
        //PRELAZAK
        context,
        MaterialPageRoute(
            builder: (context) =>
                EmailValidation(
                  valuesInput: _controllers,
                )),
      );
    } else {
      //print(res.body.toString());
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
                  'User already exists',
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
  void dispose() {
    myController.dispose();
    super.dispose();
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

  void triggerNotification() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'channelKey',
            title: "Notification Title",
            body: "Notification Content"
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onLongPress: triggerNotification,
            child: const Text("Register"),
          ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _controllers[0],
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                          registerInputDecoration("Email", "Enter Email"),
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[0]);
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
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[0],
                          controller: _controllers[1],
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration:
                          registerInputDecoration("Name", "Enter Name"),
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[1]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name must contain at least one alphabetic character';
                            } else if (value.contains(
                                RegExp('[^a-zćčđšž]', caseSensitive: false))) {
                              return 'Name cannot contain non-alphabetic characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[1],
                          controller: _controllers[2],
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration: registerInputDecoration(
                              "Last Name", "Enter Last Name"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[2]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name must contain at least one alphabetic character';
                            } else if (value.contains(
                                RegExp('[^a-zćčđšž]', caseSensitive: false))) {
                              return 'Name cannot contain non-alphabetic characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[2],
                          controller: _controllers[3],
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration: registerInputDecoration(
                              "Username", "Enter Username"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[3]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username can't be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[3],
                          controller: _controllers[4],
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Password", "Enter Password"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[4]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length <= 10) {
                              return 'Password must be longer than 10 characters';
                            }
                            else if (!value.contains(
                                RegExp('[1-9]',))) {
                              return 'Password must contain at least one digit';
                            }
                            else if (!value.contains(
                                RegExp('[A-Z]',))) {
                              return 'Password must contain at least one capital letter';
                            }
                            else if (!value.contains(
                                RegExp('[^a-zA-Z0-9]',))) {
                              return 'Password must contain a non-alphanumeric character';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[4],
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Re-enter Password", "Enter your password again"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[5]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _controllers[4].text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[5],
                          controller: _controllers[5],
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Address", "Enter Address"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[6]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[6],
                          controller: _controllers[6],
                          keyboardType: TextInputType.visiblePassword,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                            _AccountNumberFormatter(),
                            LengthLimitingTextInputFormatter(19),
                          ],
                          decoration: registerInputDecoration(
                              "Account Number",
                              "Enter Your account information"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[7]);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InternationalPhoneNumberInput(
                            focusNode: _focusInput[7],
                            textFieldController: _controllers[7],
                            countrySelectorScrollControlled: true,
                            onInputChanged: (PhoneNumber value) {},
                            autoValidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                          )),

                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: MaterialButton(
                            elevation: 10,
                            height: 50,
                            minWidth: double.infinity,
                            color: Colors.blue,
                            child: const Text("Register",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                /* print(
                                    _controllers[1].text+" "+
                                    _controllers[2].text+" "+
                                    _controllers[0].text+" "+
                                    _controllers[3].text+" "+ //username
                                    _controllers[4].text+" "+
                                    _controllers[5].text+" "+
                                    "0${_controllers[7].text} "+
                                    _controllers[6].text
                                );*/
                                registerNewUser(
                                    _controllers[1].text,
                                    _controllers[2].text,
                                    _controllers[0].text,
                                    _controllers[3].text,
                                    //username
                                    _controllers[4].text,
                                    _controllers[5].text,
                                    "0${_controllers[7].text}",
                                    _controllers[6].text
                                );
                              }
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            SignInButton(
                              Buttons.Google,
                              text: "Register with Google",
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
                              text: "Register with Facebook",
                              onPressed: () async {
                               /* await _handleSignOut();
                                await _handleSignIn;*/
                                await FacebookAuth.instance.logOut().then((value) {
                                    setState(() {
                                      _isLoggedIn = false;
                                      _userObj = {};
                                    });
                                });
                                await FacebookAuth.instance.login(
                                  permissions: ["public_profile", "email"]).then((value) {
                                    FacebookAuth.instance.getUserData().then((userData) async {
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


  /*Future signIn() async {
    await GoogleSignInApi.login();
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
//static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}*/