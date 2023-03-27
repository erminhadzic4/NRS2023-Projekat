import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nrs2023/screens/emailVaildation.dart';

import 'numberValidation.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List _focusInput = List.generate(6, (index) => FocusNode());
  final _formkey = GlobalKey<FormState>();

  final List Controllers = List.generate(6, (index) => TextEditingController());
  final myController = TextEditingController();

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
          title: const Text("Sign in"),
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
                          controller: Controllers[0],
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
                          controller: Controllers[1],
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration:
                          registerInputDecoration("Name", "Enter Name"),

                          onFieldSubmitted: (String value) {
                            FocusScope.of(context)
                                .requestFocus(_focusInput[1]);
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
                          controller: Controllers[2],
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
                          controller: Controllers[3],
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Password", "Enter Password"),
                          onChanged: (String value) {

                          },
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[3]);
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
                          focusNode: _focusInput[3],
                          controller: Controllers[4],
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Re-enter Password", "Enter your password again"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[4]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != Controllers[3].text) {
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
                          focusNode: _focusInput[4],
                          controller: Controllers[5],
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Address", "Enter Address"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[5]);
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
                            focusNode: _focusInput[5],
                            onInputChanged: (PhoneNumber value) {},
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(
                        height: 90,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: MaterialButton(
                            elevation: 10,
                            height: 50,
                            minWidth: double.infinity,
                            color: Colors.blue,
                            child: const Text("Sign in",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      EmailValidation(
                                        valuesInput: Controllers,)),
                                );
                              }
                            }
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: MaterialButton(
                          elevation: 10,
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {
                            print(Controllers[3].text);
                          },
                          color: Colors.white,
                          child: const Text("Log In",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      )
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