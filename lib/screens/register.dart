import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nrs2023/screens/emailVaildation.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List _focusInput = List.generate(6, (index) => FocusNode());
  final _formkey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final List Controllers = List.generate(6, (index) => TextEditingController());
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String? _pendingPassword;


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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80, right: 200),
                child: Text("Sign In",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 45,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key:_formkey,
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
                            if(value == null || value.isEmpty || !value.contains("@")) {
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
                            if(value == null || value.isEmpty || value.contains(RegExp(r'[0-9]'))) {
                              return 'Name cannot contain numeric characters';
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
                              "Lat Name", "Enter Last Name"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[2]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value == null || value.isEmpty || value.contains(RegExp(r'[0-9]'))) {
                              return 'Name cannot contain numeric characters';
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
                            setState(() {
                              _pendingPassword = value;
                            });
                          },
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[3]);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value == null || value.isEmpty || value.length<10) {
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
                            if(value == null || value.isEmpty || value!=_pendingPassword) {
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
                          )),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: MaterialButton(
                          elevation: 10,
                          height: 50,
                          minWidth: double.infinity,
                         /* onPressed: () {
                            if (_formkey.currentState!.validate()) {}
                          },*/
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
                          onPressed: () {},
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
