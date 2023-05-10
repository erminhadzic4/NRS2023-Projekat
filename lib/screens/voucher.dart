import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nrs2023/screens/claim.dart';

class VoucherScreen extends StatefulWidget {
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final TextEditingController _voucherController = TextEditingController();
  final TextEditingController _numVouchersController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _currencyIdController = TextEditingController();
  bool _isRedeemed = false;
  int amount = 0;
  String currencyId = "";
  String _currency = "BAM";
  String myAccount = "";
  String myToken = "";
  String adminToken = "";
  String code = "";

  @override
  void initState() {
    super.initState();
    _getAccountNumber();
    _getAdminToken();
  }

  void _getAccountNumber() async {
    String? token;
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: 'token');
    http.get(Uri.parse('https://processingserver.herokuapp.com/api/Account/GetAllAccountsForUser?token=$token'))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accountNumber = data[0]['accountNumber'];
        myAccount = accountNumber;
        print('Account Number: $accountNumber');
      } else {
        throw Exception('Failed to get accounts');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _voucherController,
                decoration: const InputDecoration(
                  labelText: 'Enter Voucher Code',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _redeemVoucher,
                child: const Text('Redeem'),
              ),
              const SizedBox(height: 20),
              if (_isRedeemed)
                Text(
                  'Congratulations! You have redeemed $amount $_currency to your account!',
                  style: const TextStyle(fontSize: 20),
                ),
              const SizedBox(height: 40),
              Text(
                'Create Voucher',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _numVouchersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of vouchers',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount of money',
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _currency,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _currency = newValue!;
                  });
                  currToId(_currency);
                  print(_currency + " " + currencyId);
                },
                items: <String>['BAM', 'USD', 'EUR', 'CHF']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _createVouchers();

                },
                child: const Text('Create Vouchers'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void redeemVoucher(String code, String accountNumber) async {
    final String apiUrl = 'http://siprojekat.duckdns.org:5051/api/VoucherRedemption/RedeemVoucher';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $adminToken',
      },
      body: jsonEncode(<String, String>{
        'code': _voucherController.text,
        'accountNumber': myAccount,
      }),
    );

    if (response.statusCode == 200) {
      print ('Voucher redeemed successfully');

    } else {
      print(_voucherController.text + " " + myAccount);
      print(response.statusCode);
      throw Exception('Failed to redeem voucher');
    }
  }

  void _redeemVoucher() {
    String voucherCode = _voucherController.text;
    if (voucherCode.isNotEmpty) {
      print("KOD " + _voucherController.text + " ACC " + myAccount);
      redeemVoucher(_voucherController.text, myAccount);
      setState(() {
        _isRedeemed = true;
        amount = int.parse(_amountController.text);
      });
      //97f5b84-ff49-4eb4-8315-61ebc5998c56
    } else {
      // Prikazi poruku greske
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid voucher code')),
      );
    }
  }


  void currToId(String curr) async {
    final response = await http.get(
      Uri.parse('http://siprojekat.duckdns.org:5051/api/ExchangeRate/currency'),
      headers: {'Authorization': 'Bearer $adminToken'},
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body).forEach((item) {

        if (item['name'] == curr) {
          currencyId = item['id'];
          print(currencyId);
        }
      });
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  void _createVouchers() async {
    print(_numVouchersController.text + " " + _amountController.text + " " + _currency + " " + adminToken);
    final url = Uri.parse('http://siprojekat.duckdns.org:5051/api/Voucher/create-voucher');
    final body = jsonEncode({
      'noVouchers': _numVouchersController.text,
      'amount': _amountController.text,
      'currencyId': currencyId
    });
    final headers = {
    'Authorization': 'Bearer $adminToken',
    'Content-Type': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
    final vouchers = jsonDecode(response.body);
    final voucherCode = vouchers[0]['code'];
    code = voucherCode;
    changeStatus();
    print(voucherCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$code"), duration: Duration(seconds: 15),),
    );
    } else {
      print("GReska");
    throw Exception('Failed to create voucher');
    }

  }

  void changeStatus() async {
    final url = Uri.parse('http://siprojekat.duckdns.org:5051/api/Voucher/change-voucher-status');
    print(code);
    final body = jsonEncode({
      'code': code,
      'statusId': "2"
    });

    final headers = {
      'Authorization': 'Bearer $adminToken',
      'Content-Type': 'application/json',
    };
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      print("Status changed");
    } else {
      print("Status changing failed");
    }
  }

  Future<void> _getAdminToken() async {
    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "abrulic1@etf.unsa.ba",
          "password": "String1!",
        }));
    if ((res.statusCode == 200) && context.mounted) {
      var responseData = jsonDecode(res.body);
      adminToken = responseData['token'];
      print(adminToken);
    }
    else {
      print(res.statusCode);
    }
  }
}
