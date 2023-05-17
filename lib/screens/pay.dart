import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nrs2023/screens/templates.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nrs2023/screens/voucherScreenQRScan.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {Key? key,
      required this.templateData,
      required String recipientName,
      required String recipientAccount,
      required String amount,
      required this.currency})
      : super(key: key);
  final List templateData;
  final String currency;

  get recipientAccount => null;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class Transaction {
  double? amount;
  String currency;
  String transactionType;
  String transactionPurpose;
  String category;
  String senderAccountNumber;
  String recipientName;
  String recipientAccountNumber;

  Transaction({
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.transactionPurpose,
    required this.category,
    required this.senderAccountNumber,
    required this.recipientName,
    required this.recipientAccountNumber,
  });

  // Convertovanje tranzakcije u JSON string
  String toJson() {
    return json.encode({
      'amount': amount,
      'currency': currency,
      'transactionType': transactionType,
      'transactionPurpose': transactionPurpose,
      'category': category,
      'senderAccountNumber': senderAccountNumber,
      'recipientName': recipientName,
      'recipientAccountNumber': recipientAccountNumber,
    });
  }

  // Pravljenje tranzakcije preko JSON string
  static Transaction fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Transaction(
      amount: jsonMap['amount'],
      currency: jsonMap['currency'],
      transactionType: jsonMap['transactionType'],
      transactionPurpose: jsonMap['transactionPurpose'],
      category: jsonMap['category'],
      senderAccountNumber: jsonMap['senderAccountNumber'],
      recipientName: jsonMap['recipientName'],
      recipientAccountNumber: jsonMap['recipientAccountNumber'],
    );
  }
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
  final _sendFormKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _recipientAccountController =
      TextEditingController();
  final TextEditingController _recipientUsername = TextEditingController();

  // final TextEditingController _recipientLastNameController =
  //    TextEditingController();
  final TextEditingController _recipientDescriptionController =
      TextEditingController();
  String _selectedCurrency = "";
  final storage = new FlutterSecureStorage();
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

  String _selectedCategory = "Pay";
  final List<String> _categories = ['Pay', 'Gift', 'Bill', 'Transfer'];

  Future<transactionValidation> validateTransaction(
      double? amount,
      String currency,
      String transactionType,
      String transactionPurpose,
      String category,
      String senderAccountNumber,
      String recipientName,
      String recipientAccountNumber) async {
    String? token = await storage.read(key: 'token');

    final uri = Uri.parse(
        "https://processingserver.herokuapp.com/api/Transaction/CreateTransaction?token=$token");

    final body = {
      "amount": amount,
      "currency": currency,
      "transactionType": transactionType,
      "transactionPurpose": transactionPurpose,
      "category": category,
      "sender": {
        "accountNumber": senderAccountNumber,
      },
      "recipient": {
        "name": recipientName,
        "accountNumber": recipientAccountNumber
      }
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
        _selectedCurrency,
        "",
        _recipientAccountController.text,
        _recipientNameController.text,
      );
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
                            "Recipient Name: ${_recipientNameController.text}"),
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
    _selectedCurrency = widget.currency;
    _amountController.text = widget.templateData[1];
    _recipientNameController.text = widget.templateData[2];
    _recipientAccountController.text = widget.templateData[3];
  }

  Future getUserId(String userName) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    final getUserId = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/$userName"),
        headers: headers);

    if (getUserId.statusCode != 200) {
      return null;
    }

    return json.decode(getUserId.body)['id'];
  }

  Future sendTemplate(String? currency, String? amount, String? name,
      String? account, String? username) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var userId = await getUserId(username!);

    if (userId == null) {
      return null;
    }

    var body = {
      "userId": userId,
      "title": "string",
      "amount": amount,
      "paymentType": "string",
      "description": "string",
      "currency": currency,
      "recipientName": name,
      "recipientAccountNumber": account,
      "phoneNumber": "string",
      "category": "string",
      "received": "true"
    };

    final sendUserTemplate = await http.post(
        Uri.parse('http://siprojekat.duckdns.org:5051/api/Template'),
        headers: headers,
        body: json.encode(body));

    return json.decode(sendUserTemplate.body);
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
        body: SingleChildScrollView(
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
                  decoration: InputDecoration(hintText: "0.00"),
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
                ),
                SizedBox(height: 16),
                Text('Recipient Name'),
                TextFormField(
                  controller: _recipientNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient first name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter recipient first name',
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
                  value: _selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitPaymentForm,
                      child: Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoucherScreenQRScan()),
                        );
                      },
                      child: Text('Voucher'),
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
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                        'Enter username to send template to'),
                                    content: Form(
                                      key: _sendFormKey,
                                      child: TextFormField(
                                        controller: _recipientUsername,
                                        decoration: InputDecoration(
                                            labelText: 'Recipient username'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Recipient name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (_sendFormKey.currentState!
                                              .validate()) {
                                            var sent = await sendTemplate(
                                                _selectedCurrency,
                                                _amountController.text,
                                                _recipientNameController.text,
                                                _recipientAccountController
                                                    .text,
                                                _recipientUsername.text);
                                            if (sent != null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          content: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Template sent succesfully !'),
                                                              Icon(
                                                                Icons.check_box,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            )
                                                          ]));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          content: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'No user with that username !'),
                                                              Icon(
                                                                Icons.clear,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            )
                                                          ]));
                                            }
                                          }
                                        },
                                        child: Text('Send'),
                                      ),
                                    ]);
                              });
                        }
                      },
                      child: Text('Send'),
                    ),
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
