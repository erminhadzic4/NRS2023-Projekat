import 'dart:convert';
import 'package:nrs2023/screens/emailVaildation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List _focusInput = List.generate(7, (index) => FocusNode());
  final _formkey = GlobalKey<FormState>();

  final List _controllers =
      List.generate(8, (index) => TextEditingController());
  final myController = TextEditingController();

  void registerNewUser(
      String firstName,
      String lastName,
      String email,
      String username,
      String password,
      String address,
      String phoneNumber) async {
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/Register"),
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
          "phoneNumber": phoneNumber
        }));
    if (res.statusCode == 200 && context.mounted) {
      Navigator.push(
        //PRELAZAK
        context,
        MaterialPageRoute(
            builder: (context) => EmailValidation(
                  valuesInput: _controllers,
                )),
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
                  'Username already exists',
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
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
                padding: const EdgeInsets.symmetric(vertical: 30),
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
                        height: 20,
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
                        height: 20,
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
                        height: 20,
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
                        height: 20,
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
                                value.length < 10) {
                              return 'Password must be longer than 10 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                        height: 20,
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
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InternationalPhoneNumberInput(
                            focusNode: _focusInput[6],
                            textFieldController: _controllers[6],
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
                        height: 40,
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
                                registerNewUser(
                                    _controllers[1].text,
                                    _controllers[2].text,
                                    _controllers[0].text,
                                    _controllers[3].text, //username
                                    _controllers[4].text,
                                    _controllers[5].text,
                                    "0${_controllers[6].text}");

                              }
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [

                            SignInButton(
                              Buttons.Google,
                              text: "Register with Google",
                              onPressed: () {},
                            ),
                            SignInButton(
                              Buttons.Facebook,
                              text: "Register with Facebook",
                              onPressed: () {},
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
