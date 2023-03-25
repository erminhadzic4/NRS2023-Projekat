import 'package:flutter/material.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final _formKey = GlobalKey<FormState>();

  late String _transactionAmount;
  late String _recipientName;
  late String _recipientAccount;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Transaction complete'),
          content: Text('Your transaction has been completed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      // dismiss the keyboard when the user taps anywhere on the screen
      FocusScope.of(context).unfocus();
      // validate the form and show any validation errors
      _formKey.currentState?.validate();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('New Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Transaction Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == "") {
                    return 'Please enter a transaction amount';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _transactionAmount = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Recipient Name'),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter recipient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _recipientName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Recipient Account'),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter recipient account';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid account number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _recipientAccount = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
