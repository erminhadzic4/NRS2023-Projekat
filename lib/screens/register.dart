import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List _focusInput = List.generate(6, (index) => FocusNode());

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
        //resizeToAvoidBottomInset: false,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              registerInputDecoration("Email", "Enter Email"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[0]);
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
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            decoration:
                                registerInputDecoration("Name", "Enter Name"),
                            onChanged: (String value) {},
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context)
                                  .requestFocus(_focusInput[1]);
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          focusNode: _focusInput[1],
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration: registerInputDecoration(
                              "Lat Name", "Enter Last Name"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[2]);
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
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Password", "Enter Password"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[3]);
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
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: registerInputDecoration(
                              "Re-enter Password", "Enter your password again"),
                          onChanged: (String value) {},
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(_focusInput[4]);
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
                          onPressed: () {},
                          color: Colors.blue,
                          child: const Text("Sign in",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
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
