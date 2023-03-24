import 'package:flutter/material.dart';
import 'package:nrs2023/screens/register.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({Key? key}) : super(key: key);

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation>{
  final List _focusInput = List.generate(6, (index) => FocusNode());
  final _formkey = GlobalKey<FormState>();

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
            title: Text("Verify e-mail"),
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
                             width: 300,
                            child: Text("Email confirmation",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                //textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold)),
                          ),
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
                                  child: const Text("Verify",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
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