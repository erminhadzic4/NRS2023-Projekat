import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nrs2023/screens/transactions.dart';

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

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _recipientAccountController =
      TextEditingController();
  final TextEditingController _recipientDescriptionController =
      TextEditingController();

  String _selectedType = "One-time donation";
  final List<String> _types = [
    "One-time donation",
    "Long-term donation",
  ];
  String _selectedFrequency = "Every day";
  final List<String> _frequency = [
    "Every day",
    "Every week",
    "Every month",
    "Every year",
  ];

  String _selectedDuration = "Week";
  final List<String> _duration = [
    "Week",
    "Month",
    "Year",
  ];

  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Donation'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text('Recipient Name'),
                TextFormField(
                  controller: _recipientNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient first name is required';
                    } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                      return 'Recipient name can only contain letters and spaces';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient first name',
                  ),
                ),
                SizedBox(height: 8),
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
                SizedBox(height: 8),
                Text('Category'),
                Column(
                  children: _types
                      .map(
                        (donationType) => RadioListTile<String>(
                          title: Text(donationType),
                          value: donationType,
                          groupValue: _selectedType,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 8),
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
                SizedBox(height: 8),
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
                Column(
                  children: <Widget>[
                    if (_selectedType == "Long-term donation")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8),
                          Text(
                            'Frequency of donation',
                            textAlign: TextAlign.left,
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedFrequency,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedFrequency = value!;
                              });
                            },
                            items: _frequency
                                .map(
                                  (currency) => DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 8),
                          Text('Duration of the donation'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _durationController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d]')),
                                    ],
                                    validator: (value) {
                                      if (_durationController.text.isNotEmpty &&
                                          double.tryParse(
                                                  _durationController.text) ==
                                              0) {
                                        return 'Duration of the donation is required';
                                      } else if (double.tryParse(
                                              _durationController.text) ==
                                          null) {
                                        return 'Duration of the donation should be a valid number.';
                                      } else if (double.parse(
                                              _durationController.text) >
                                          1000) {
                                        return 'Duration of the donation cannot be greater than 1000';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: '1',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedDuration,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedDuration = value!;
                                      });
                                    },
                                    items: _duration
                                        .map(
                                          (duration) => DropdownMenuItem(
                                            value: duration,
                                            child: Text(duration),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ]),
                          SizedBox(width: 8),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Transaction Details'),
                TextFormField(
                  controller: _recipientDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter transaction details',
                  ),
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'You have successfully donated!'), // Your message here
                              ),
                            );
                          }
                        },
                        child: const Text('Donate')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
