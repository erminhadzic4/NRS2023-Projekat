import 'package:flutter/material.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/numberValidation.dart';
import 'package:flutter/gestures.dart';

import 'numberValidation.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({Key? key, required this.valuesInput}) : super(key: key);

  final List valuesInput;

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation>{
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
    String mail = widget.valuesInput[0].text;
    mail = mail.replaceAll(RegExp(r'(?<=.)[^@](?=[^@]*?@)|(?:(?<=@.)|(?!^)\\G(?=[^@]*$)).(?=.*[^@]\\.)'),'*');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Verify e-mail"),
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
                             width: 350,
                            child: Text("Confirm email",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        width: 350,
                        child: Text('Hi ${widget.valuesInput[1].text} ${widget.valuesInput[2].text},',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 350,
                        child: Text('we just sent a confirmation pin to $mail',// + myController.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18)),
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
                                  registerInputDecoration("Pin", "Enter Pin"),
                                  onFieldSubmitted: (String value) {
                                    //FocusScope.of(context).requestFocus(_focusInput[0]);
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if(value == null || value.isEmpty || value.length < 6 || value.contains(RegExp(r'[A-Za-z]'))) {
                                      return 'Invalid pin';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 350,
                                  child: Text.rich(
                                    textAlign: TextAlign.center,
                                      TextSpan(
                                        text: "Didn't receive code? ",
                                        children: [
                                          TextSpan(
                                              text: 'Resend code',
                                              style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                                            mouseCursor: SystemMouseCursors.click,
                                            recognizer: TapGestureRecognizer()..onTap = () => {},
                                          ),
                                        ],
                                      ),
                                  )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: MaterialButton(
                                  elevation: 10,
                                  height: 50,
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NumberValidation()),
                                    );
                                  },
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