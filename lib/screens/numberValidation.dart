import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/home.dart';

class NumberValidation extends StatefulWidget {
  const NumberValidation({Key? key}) : super(key: key);

  @override
  State<NumberValidation> createState() => _NumberValidationState();
}

class _NumberValidationState extends State<NumberValidation> {
  String _confirmationCode = '';
  bool logged = false;

  void _onCodeChanged(String value) {
    setState(() {
      _confirmationCode = value;
    });
  }

  void _onConfirmPressed() {
    String correctCode = '123456';

    if (_confirmationCode == correctCode) {
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
                  'Your phone number has been confirmed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  logged = true;
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
                  'The confirmation code is incorrect.',
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
  Widget build(BuildContext context) {
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Verify number"),
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
                  child: Text("Confirm phone number",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 33,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 350,
                  child: Text(
                      'We just sent a confirmation code to your number!', // + myController.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black87, fontSize: 18)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onChanged: (value) {
                            _onCodeChanged(value);
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              registerInputDecoration("Pin", "Enter Pin"),
                          onFieldSubmitted: (String value) {},
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6 ||
                                value.contains(RegExp(r'[A-Za-z]'))) {
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
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                    mouseCursor: SystemMouseCursors.click,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {},
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
                            _onConfirmPressed();
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
