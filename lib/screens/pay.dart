import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PaymentPage extends StatefulWidget {

  final String recipientName;
  final String recipientAccount;
  final String amount;
  final String currency;

  const PaymentPage({Key? key,
    required this.recipientName,
    required this.recipientAccount,
    required this.amount,
    required this.currency,
}): super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text.replaceAll('-', '');
    String formattedValue = '';
    for (int i = 0; i < value.length; i++) {
      formattedValue += value[i];
      if ((i + 1) % 4 == 0 && i != value.length - 1) {
        formattedValue += '-';
      }
    }
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientAccountController = TextEditingController();
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
  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount;
    _selectedCurrency = widget.currency;
    _recipientNameController.text = widget.recipientName;
    _recipientAccountController.text = widget.recipientAccount;
  }

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
            leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
            )),
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (_amountController.text.isNotEmpty &&
                        double.tryParse(_amountController.text) == 0.0) {
                      return 'Amount is required';
                    } else if (double.tryParse(_amountController.text) ==
                        null) {
                      return 'Amount should be a valid number.';
                    } else if (double.parse(_amountController.text) > 100000) {
                      return 'Amount cannot be greater than 100 000';
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
                    } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                      return 'Recipient name can only contain letters and spaces';
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                    _AccountNumberFormatter(),
                    LengthLimitingTextInputFormatter(19),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient account details are required';
                    } else if (value.replaceAll('-', '').length != 16) {
                      return 'Recipient account number must be 16 digits';
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
