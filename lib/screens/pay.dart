import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nrs2023/screens/templates.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {Key? key,
      required this.templateData,
      required String recipientName,
      required String recipientAccount,
      required String amount,
      required String currency,
      this.transactionCategory})
      : super(key: key);
  final List templateData;
  final String? transactionCategory;

  get recipientAccount => null;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class transactionValidation {
  late bool success;
  late String message;

  transactionValidation(this.success, this.message);
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
  final TextEditingController _recipientFirstNameController =
      TextEditingController();
  final TextEditingController _recipientAccountController =
      TextEditingController();
  final TextEditingController _recipientLastNameController =
      TextEditingController();
  final TextEditingController _recipientDescriptionController =
      TextEditingController();
  final storage = new FlutterSecureStorage();
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
  String? selectedCategory = "Currency";
  final List<String> category = ['Currency','Amount','Recipient Account', 'Transaction Details'];

  Future<transactionValidation> validateTransaction(
      double? amount,
      String currency,
      String paymentType,
      String description,
      String recipientAccountNumber,
      String firstName,
      String lastName) async {
    String? token = await storage.read(key: 'token');

    final uri = Uri.parse(
        "https://processingserver.herokuapp.com/Transaction/CreateTransaction?token=$token");

    final body = {
      "amount": amount,
      "currency": currency,
      "paymentType": paymentType,
      "description": description,
      "recipientAccountNumber": recipientAccountNumber,
      "recipientFirstName": firstName,
      "recipientLastName": lastName
    };

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    final response =
        await http.post(uri, headers: headers, body: json.encode(body));

    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return transactionValidation(true, 'success');
    }
    return transactionValidation(false, jsonResponse['message']);
  }

  void _submitPaymentForm() async {
    if (_formKey.currentState!.validate()) {
      var isValidRecipient = await validateTransaction(
          double.tryParse(_amountController.text),
          _selectedCurrency,
          "type",
          _recipientDescriptionController.text,
          _recipientAccountController.text,
          _recipientFirstNameController.text,
          _recipientLastNameController.text);
      if (!isValidRecipient.success) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${isValidRecipient.message}'),
                        Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      )
                    ]));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Transaction Succesfull '),
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            "Recipient Name: ${_recipientFirstNameController.text}"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Amount: ${_amountController.text} $_selectedCurrency"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Recipient Account: ${_recipientAccountController.text}")
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    _amountController.text = widget.templateData[1];
    _recipientFirstNameController.text = widget.templateData[2];
    _recipientAccountController.text = widget.templateData[3];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
                Text('Recipient First Name'),
                TextFormField(
                  controller: _recipientFirstNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient first name is required';
                    } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                      return 'Recipient first name can only contain letters and spaces';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient first name',
                  ),
                ),
                SizedBox(height: 16),
                Text('Recipient Last Name'),
                TextFormField(
                  controller: _recipientLastNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient last name is required';
                    } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                      return 'Recipient last name can only contain letters and spaces';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient last name',
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
                Text('Transaction Details'),
                TextFormField(
                  controller: _recipientDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter transaction details',
                  ),
                ),
                SizedBox(height: 16),
                Text('Transaction Category'),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: category
                      .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ))
                      .toList(),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitPaymentForm,
                      child: Text('Submit'),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TemplatesPage()),
                        );
                      },
                      child: Text("Templates"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
