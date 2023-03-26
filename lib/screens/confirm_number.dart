import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmNumber extends StatefulWidget {
  const ConfirmNumber({Key? key}) : super(key: key);

  @override
  State<ConfirmNumber> createState() =>
      _ConfirmNumberState();
}

class _ConfirmNumberState
    extends State<ConfirmNumber> {
  String _confirmationCode = '';

  void _onCodeChanged(String value) {
    setState(() {
      _confirmationCode = value;
    });
  }

  void _onConfirmPressed() {
    // You can set this variable to the correct confirmation code for testing purposes
    String correctCode = '123456';

    if (_confirmationCode == correctCode) {
      // Show success message if the entered code is correct
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
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show failure message if the entered code is incorrect
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Number Confirmation',
      home: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Please enter the confirmation code sent to your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Confirmation code (6 digits)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _onCodeChanged,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _confirmationCode.length == 6
                                ? _onConfirmPressed
                                : null,
                            child: const Text('Confirm'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              //TODO: Handle resend code logic here
                            },
                            child: const Text('Resend code'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Do it later',
                        style: TextStyle(
                          color: Colors.blue
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}
