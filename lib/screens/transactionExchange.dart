import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'accountList.dart';

class TransactionExchangePage extends StatefulWidget {
  @override
  _TransactionExchangeState createState() => _TransactionExchangeState();
}

class _TransactionExchangeState extends State<TransactionExchangePage> {
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  List<Accounts> _accounts = [];

  Future getUserAccounts() async {
    _accounts.clear();
    String? token = await storage.read(key: 'token');

    print(token);
    final getAccounts = await http.get(
      Uri.parse(
          'http://siprojekat.duckdns.org:5051/api/Exchange/GetUserAccounts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'authorization': 'Bearer $token'
      },
    );

    var accountsList = json.decode(getAccounts.body);
    // print(accountsList);

    for (int i = 0; i < accountsList.length; i++) {
      String currency = accountsList[i]['currency'];
      String bankName = accountsList[i]['bankName'];
      String accountNumber = accountsList[i]['accountNumber'];

      var account = Accounts(
        currency: currency,
        bankName: bankName,
        account: accountNumber,
      );
      //   print(account);
      _accounts.add(account);
    }
  }

  final _purpose = TextEditingController();
  double _exchangeRate = 1.0;
  double _amountToExchange = 0.0;
  String _selectedCurrency = 'USD';
  final List<String> _currencies = ['USD', 'BAM', 'CHF', 'EUR'];

  List<String> _availableCurrencies = [];

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    String? token = await storage.read(key: 'token');
    //  print(token);
    try {
      final response = await http.get(
          Uri.parse(
              "http://siprojekat.duckdns.org:5051/api/ExchangeRate/currency"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': 'Bearer $token'
          });
      //   print(json.decode(response.body));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final currencies = responseData as List<dynamic>;
        setState(() {
          _availableCurrencies = currencies.cast<String>();
          _selectedCurrency = _currencies[0];
          //  print(_selectedCurrency);
        });
        await getExchangeRate();
      } else {
        // Handle error response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to fetch the available currencies: $_availableCurrencies'),
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
    } catch (e) {
      //print(e);
      // Handle network or other errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred while fetching the available currencies.'),
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

  Future<String?> getUserCurrency() async {
    String? token = await storage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'authorization': 'Bearer $token'
    };

    final getAccounts = await http.get(
      Uri.parse(
          'http://siprojekat.duckdns.org:5051/api/Exchange/GetUserAccounts'),
      headers: headers,
    );

    final accountsList = json.decode(getAccounts.body);
    if (accountsList.isNotEmpty) {
      final currency = accountsList[0]['currency'];
      print(currency);
      return currency.toString();
    }
    return null; // Return null when the user has no accounts
  }

  Future<void> getExchangeRate() async {
    String? token = await storage.read(key: 'token');
    String? userCurrency = await getUserCurrency();

    try {
      final response = await http.get(
        Uri.parse(
            "http://siprojekat.duckdns.org:5051/api/ExchangeRate?inputCurreny=$userCurrency&outputCurrency=$_selectedCurrency"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print(responseData);

        final exchangeRate = responseData[0]['rate'];
        print(exchangeRate);

        setState(() {
          _exchangeRate = exchangeRate;
          _amountToExchange = _exchangeRate * _amountToExchange;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch the exchange rate.'),
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
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while fetching the exchange rate.'),
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

  Future<void> createExchangeTransaction() async {
    String? token = await storage.read(key: 'token');
    var account = await getUserAccounts();

    String? userCurrency = await getUserCurrency();

    try {
      final response = await http.post(
          Uri.parse(
              "http://siprojekat.duckdns.org:5051/api/Exchange/CreateExchangeTransaction"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            "amount": _amountToExchange,
            "transactionPurpose": _purpose.text,
            "senderCurrency": userCurrency,
            "recipientCurrnecy": _selectedCurrency,
          }));
      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200) {
        // Transaction successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Transaction complete'),
            content: Text('Your transaction exchange has been completed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle error response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create the exchange transaction.'),
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
    } catch (e) {
      print(e);
      // Handle network or other errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred while creating the exchange transaction.'),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Transaction exchange'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Select currency to exchange:'),
                DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  onChanged: (String? value) async {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                  items: _currencies
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
                Text('Amount to exchange: $_amountToExchange'),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _amountToExchange = double.tryParse(value) ?? 0.0;
                    });
                  },
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
                TextFormField(
                  controller: _purpose,
                  decoration: InputDecoration(
                    hintText: 'Exchange purpose',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                    'Exchange rate (Current currency to $_selectedCurrency): $_exchangeRate '),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createExchangeTransaction();
                    }
                  },
                  child: Text('Exchange'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
