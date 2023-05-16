import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nrs2023/screens/pay.dart';

class Payment {
  TextEditingController? Currency = TextEditingController();
  TextEditingController? Amount = TextEditingController();
  TextEditingController? RecipientName = TextEditingController();
  TextEditingController? RecipientAccount = TextEditingController();
  int? templateId;

  Payment({
    required this.Currency,
    required this.Amount,
    required this.RecipientName,
    required this.RecipientAccount,
    this.templateId,
  });
}

class TemplatesPage extends StatefulWidget {
  @override
  _TemplatesPageState createState() => _TemplatesPageState();
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

class _TemplatesPageState extends State<TemplatesPage> {
  List<Payment> templates = [];
  final storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  String? _selectedCurrency = "USD";
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
  }

  // Fetch funkcije za back-end

  Future getUserId() async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    final getUserName = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User"),
        headers: headers);

    var userName = jsonDecode(getUserName.body)['userName'];

    final getUserId = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/$userName"),
        headers: headers);

    return json.decode(getUserId.body)['id'];
  }

  Future getTemplates() async {
    templates.clear();
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    var userId = await getUserId();

    final getUserTemplates = await http.get(
        Uri.parse(
            "http://siprojekat.duckdns.org:5051/api/Template/User/$userId"),
        headers: headers);

    var userTemplates = json.decode(getUserTemplates.body);

    for (int i = 0; i < userTemplates.length; i++) {
      TextEditingController? Currency =
          TextEditingController(text: userTemplates[i]['currency']);
      TextEditingController? Amount =
          TextEditingController(text: userTemplates[i]['amount']);
      TextEditingController? RecipientName =
          TextEditingController(text: userTemplates[i]['recipientName']);
      TextEditingController? RecipientAccount = TextEditingController(
          text: userTemplates[i]['recipientAccountNumber']);

      var template = Payment(
          Currency: Currency,
          Amount: Amount,
          RecipientName: RecipientName,
          RecipientAccount: RecipientAccount,
          templateId: userTemplates[i]['id']);
      templates.add(template);
    }
  }

  Future sendTemplate(
      String? currency, String? amount, String? name, String? account) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var userId = await getUserId();

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
      "received": "false"
    };

    final sendUserTemplate = await http.post(
        Uri.parse('http://siprojekat.duckdns.org:5051/api/Template'),
        headers: headers,
        body: json.encode(body));

    return json.decode(sendUserTemplate.body);
  }

  Future deleteTemplateBE(int id) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    final deleteTemplate = await http.delete(
      Uri.parse('http://siprojekat.duckdns.org:5051/api/Template/$id'),
      headers: headers,
    );

    return json.decode(deleteTemplate.body);
  }

  Future editTemplateBE(int? id, String? currency, String? amount, String? name,
      String? account) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    var userId = await getUserId();
    print(currency);

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
      "received": "string"
    };

    final editUserTemplate = await http.put(
        Uri.parse('http://siprojekat.duckdns.org:5051/api/Template/$id'),
        headers: headers,
        body: json.encode(body));

    return json.decode(editUserTemplate.body);
  }

  void _sendTemplateData(index) {
    if (index >= 0 && index < templates.length) {
      var template = Payment(
        Currency: templates[index].Currency,
        Amount: templates[index].Amount,
        RecipientName: templates[index].RecipientName,
        RecipientAccount: templates[index].RecipientAccount,
      );

      List<String?> data = [
        template.Currency?.text.toString(),
        template.Amount?.text.toString(),
        template.RecipientName?.text.toString(),
        template.RecipientAccount?.text.toString(),
      ];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            templateData: data,
            recipientName: template.RecipientName?.text.toString() ?? '',
            recipientAccount: template.RecipientAccount?.text.toString() ?? '',
            amount: template.Amount?.text.toString() ?? '',
            currency: template.Currency?.text.toString() ?? '',
          ),
        ),
      );
    } else {
      // Handle the case when index is invalid
      print('Invalid index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Templates'),
      ),
      body: FutureBuilder(
        future: getTemplates(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return ListTile(
                  title: Text(template.RecipientName!.text),
                  subtitle: Text(template.RecipientAccount!.text),
                  trailing:
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.account_balance_wallet),
                      onPressed: () {
                        _sendTemplateData(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editTemplate(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await deleteTemplateBE(template.templateId!);
                        setState(() {
                          templates.removeAt(index);
                        });
                      },
                    ),
                  ]),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTemplate,
        child: Icon(Icons.add),
      ),
    );
  }

  // void deleteTemplate(int? index) {
  //   setState(() {
  //     deleteTemplate(templates.elementAt(index!).templateId);
  //   });
  // }

  void editTemplate(int index) {
    final _currencyController = templates[index].Currency;
    final _amountController = templates[index].Amount;
    final _recipientNameController = templates[index].RecipientName;
    final _recipientAccountController = templates[index].RecipientAccount;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit template'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    value: _currencyController?.text,
                    onChanged: (value) {
                      setState(() {
                        _currencyController?.text = value!;
                      });
                    },
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Currency',
                      hintText: 'Select currency',
                    ),
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (_amountController?.text == null) {
                        return 'Amount is required';
                      } else if (double.tryParse(_amountController!.text) ==
                          null) {
                        return 'Amount should be a valid number.';
                      } else if (double.parse(_amountController!.text) >
                          100000) {
                        return 'Amount cannot be greater than 100 000!';
                      } else if (double.parse(_amountController!.text) == 0) {
                        return 'Amount cannot be 0!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.00',
                    ),
                  ),
                  TextFormField(
                    controller: _recipientNameController,
                    decoration: InputDecoration(labelText: 'Recipient name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Recipient name is required';
                      } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                        return 'Recipient name can only contain letters and spaces';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _recipientAccountController,
                    decoration: InputDecoration(labelText: 'Recipient account'),
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
                  ),
                ],
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      editTemplateBE(
                          templates.elementAt(index).templateId,
                          _selectedCurrency!,
                          _amountController?.text,
                          _recipientNameController?.text,
                          _recipientAccountController?.text);
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }

  void addTemplate() {
    final _currencyController = TextEditingController();
    final _amountController = TextEditingController();
    final _recipientNameController = TextEditingController();
    final _recipientAccountController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Create a new template'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    value: _selectedCurrency,
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    },
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Currency',
                      hintText: 'Select currency',
                    ),
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (_amountController.text.isEmpty) {
                        return 'Amount is required';
                      } else if (double.tryParse(_amountController.text) ==
                          null) {
                        return 'Amount should be a valid number.';
                      } else if (double.parse(_amountController.text) >
                          100000) {
                        return 'Amount cannot be greater than 100 000!';
                      } else if (double.parse(_amountController.text) == 0) {
                        return 'Amount cannot be 0!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: '0.00',
                    ),
                  ),
                  TextFormField(
                    controller: _recipientNameController,
                    decoration: InputDecoration(labelText: 'Recipient name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Recipient name is required';
                      } else if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                        return 'Recipient name can only contain letters and spaces';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _recipientAccountController,
                    decoration: InputDecoration(labelText: 'Recipient account'),
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
                  ),
                ],
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    /*  Payment newPayment = Payment(
                        Currency: _currencyController,
                        Amount: _amountController,
                        RecipientName: _recipientNameController,
                        RecipientAccount: _recipientAccountController); */
                    setState(() {
                      sendTemplate(
                          _selectedCurrency,
                          _amountController?.text,
                          _recipientNameController?.text,
                          _recipientAccountController?.text);
                      // templates.add(newPayment);
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }
}
