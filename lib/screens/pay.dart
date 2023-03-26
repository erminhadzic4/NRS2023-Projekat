import 'package:flutter/material.dart';

// class Pay extends StatefulWidget {
//   @override
//   _PayState createState() => _PayState();
// }
//
// class _PayState extends State<Pay> {
//   final _formKey = GlobalKey<FormState>();
//
//   late String _transactionAmount;
//   late String _recipientName;
//   late String _recipientAccount;
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _goToPaymentPage();
//     }
//   }
//
//   bool validatePayInfo(String amount, String name, String account) {
//     // Check if all fields are non-empty
//     if (amount.isEmpty || name.isEmpty || account.isEmpty) {
//       return false;
//     }
//
//     // Check if the amount is a valid number
//     try {
//       double.parse(amount);
//     } catch (e) {
//       return false;
//     }
//
//     // Check if the account number is a valid format (e.g., 10 digits)
//     if (account.length != 10) {
//       return false;
//     }
//
//     // All checks passed, the information is valid
//     return true;
//   }
//
//   void Pay(BuildContext context) {
//     // Validate the pay information
//     if (validatePayInfo(_transactionAmount, _recipientName, _recipientName)) {
//       // Navigate to the PaymentPage
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PaymentPage()),
//       );
//     } else {
//       // Display an error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid pay information')),
//       );
//     }
//   }
//
//   void _goToPaymentPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PaymentPage()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // dismiss the keyboard when the user taps anywhere on the screen
//         FocusScope.of(context).unfocus();
//         // validate the form and show any validation errors
//         _formKey.currentState?.validate();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('New Transaction'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Transaction Amount'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == "") {
//                       return 'Please enter a transaction amount';
//                     }
//                     if (double.tryParse(value!) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _transactionAmount = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Recipient Name'),
//                   validator: (value) {
//                     if (value == "") {
//                       return 'Please enter recipient name';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _recipientName = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Recipient Account'),
//                   validator: (value) {
//                     if (value == "") {
//                       return 'Please enter recipient account';
//                     }
//                     if (int.tryParse(value!) == null) {
//                       return 'Please enter a valid account number';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _recipientAccount = value!;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _recipientAccountController =
      TextEditingController();
  String _selectedCurrency = "USD";
  final List<String> _currencies = [
    'USD',
    'AUD',
    'BRL',
    'CAD',
    'CHF',
    'CZK',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'HUF',
    'ILS',
    'JPY',
    'MXN',
    'NOK',
    'NZD',
    'PHP',
    'PLN',
    'RUB',
    'SEK',
    'SGD',
    'THB',
    'TWD'
  ];

  void _submitPaymentForm() {
    if (_formKey.currentState!.validate()) {
      if (_recipientNameController.text.isEmpty ||
          _recipientAccountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recipient name or account details are required.'),
        ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Transaction complete'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Payment'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Currency'),
                DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                  items: _currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                Text('Amount'),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_amountController.text.isNotEmpty &&
                        double.tryParse(_amountController.text) == 0.0) {
                      return 'Amount is required';
                    } else if (double.tryParse(_amountController.text) ==
                        null) {
                      return 'Amount should be a valid number.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixText: _selectedCurrency,
                    suffixStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    hintText: '0.00',
                  ),
                ),
                SizedBox(height: 16),
                Text('Recipient Name'),
                TextFormField(
                  controller: _recipientNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient name',
                  ),
                ),
                SizedBox(height: 16),
                Text('Recipient Account'),
                TextFormField(
                  controller: _recipientAccountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient account details are required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient account details',
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPaymentForm,
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
