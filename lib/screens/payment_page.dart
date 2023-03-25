import 'package:flutter/material.dart';

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
  final List<String> _currencies = ['USD', 'AUD', 'BRL', 'CAD', 'CHF', 'CZK', 'DKK', 'EUR', 'GBP', 'HKD', 'HUF', 'ILS', 'JPY', 'MXN', 'NOK', 'NZD', 'PHP', 'PLN', 'RUB', 'SEK', 'SGD', 'THB', 'TWD'];

  void _submitPaymentForm() {
    if (_formKey.currentState!.validate()) {
      if (_recipientNameController.text.isEmpty ||
          _recipientAccountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recipient name or account details are required.'),
        ));
      } else {
        // treba uraditi ConfirmationPage()
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Payment'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
