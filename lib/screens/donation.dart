import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../auth_provider.dart';

class Vendor {
  int id;
  String name;
  String address;
  String companyDetails;
  String phone;
  DateTime created;
  List<User>? assignedUsers;

  Vendor(
    this.id,
    this.name,
    this.address,
    this.companyDetails,
    this.phone,
    this.created,
    this.assignedUsers,
  );

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
        json['id'],
        json['name'],
        json['address'],
        json['companyDetails'],
        json['phone'],
        DateTime.parse(json['created']),
        (json['assignedUsers'] as List<dynamic>)
            .map((userData) => User.fromJson(userData))
            .toList());
  }
}

class VendorAccount {
  String? accountNumber;
  DateTime? createdAt;
  String? currency;
  String? bankName;
  String? description;
  double? credit;
  double? debit;
  double? total;
  Vendor? owner;
  User? creator;

  VendorAccount({
    required this.accountNumber,
    required this.createdAt,
    required this.currency,
    required this.bankName,
    required this.description,
    required this.credit,
    required this.debit,
    required this.total,
    required this.owner,
    required this.creator,
  });

  factory VendorAccount.fromJson(Map<String, dynamic> json) {
    return VendorAccount(
      accountNumber: json['accountNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      currency: json['currency'],
      bankName: json['bankName'],
      description: json['description'],
      credit: json['credit'],
      debit: json['debit'],
      total: json['total'],
      owner: Vendor.fromJson(json['owner']),
      creator: User.fromJson(json['creator']),
    );
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? address;
  String? accountNumber;
  String? type;
  String? email;
  String? phoneNumber;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.accountNumber,
    required this.type,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      accountNumber: json['accountNumber'],
      type: json['type'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class DonationPage extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<DonationPage> {
  List<Vendor> vendors = []; // Rename Vendors to vendors
  List<VendorAccount> vendorsAccounts = []; // Rename Vendors to vendors

  String _selectedVendor = ""; // Initialize with an empty string
  String _selectedVendorAccount = "Izaberi account";

  Future<void> getVendors() async {
    var link = "http://siprojekat.duckdns.org:5051/api/Vendor";
    final url = Uri.parse(link);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = response.body;

    if (responseBody.isNotEmpty) {
      try {
        final responseData = json.decode(responseBody);
        responseData.forEach((vendorData) {
          vendors.add(Vendor.fromJson(vendorData));
        });

        if (vendors.isNotEmpty) {
          setState(() {
            _selectedVendor = vendors[0].id.toString();
          });
        }
      } catch (e) {
        // Handle JSON decoding exception
        print('Error decoding JSON: $e');
        // Handle the error in an appropriate way (e.g., display an error message)
      }
    } else {
      // Handle empty response body
      print('Empty response received');
      // Handle the empty response in an appropriate way
    }
  }

  Future<void> _getVendorsAccounts(int vendorID) async {
    var link =
        "https://processingserver.herokuapp.com/api/VendorBankAccount/GetBankAccountsForVendor?token=" +
            token +
            "&vendorId=" +
            vendorID.toString();
    final url = Uri.parse(link);
    final response = await http.get(url);
    print(response.body);
    final responseData = json.decode(response.body);
    responseData.forEach((vendorBankData) {
      vendorsAccounts.add(VendorAccount.fromJson(vendorBankData));
    });

    if (vendorsAccounts.isNotEmpty) {
      setState(() {
        _selectedVendorAccount = vendorsAccounts[0].accountNumber!;
      });
    }
  }

  var token;
  @override
  void initState() {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = _authProvider.token;
    getVendors();
    super.initState();
  }

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
  String get selectedType => _selectedType;

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

  String? _validateDuration(String duration) {
    if ((_selectedFrequency == "Every year" &&
            ((duration == "Week" &&
                    int.tryParse(_durationController.text)! < 52) ||
                duration == "Month" &&
                    int.tryParse(_durationController.text)! < 12)) ||
        (_selectedFrequency == "Every month" &&
                (duration == "Week" &&
                    int.tryParse(_durationController.text)! < 4) ||
            (duration == "Month" &&
                int.tryParse(_durationController.text)! < 1)) ||
        (_selectedFrequency == "Every week" &&
            (duration == "Week" &&
                int.tryParse(_durationController.text)! < 1)))
      return 'Duration is invalid.';
    else
      return null;
  }

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
                Text('Business Name'),
                DropdownButtonFormField<String>(
                  value: _selectedVendor,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedVendor = value!;
                      _getVendorsAccounts(8);
                    });
                  },
                  items: vendors.map<DropdownMenuItem<String>>((Vendor vendor) {
                    return DropdownMenuItem<String>(
                      value: vendor.id.toString(),
                      child: Text(vendor.name),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
                Text('Vendors Account Number'),
                TextFormField(
                  controller: _recipientAccountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(7),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Recipient account details are required';
                    } else if (value.replaceAll('-', '').length != 7) {
                      return 'Recipient account number must be 7 characters';
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
                  children: [
                    RadioListTile(
                      title: Text('One-time donation'),
                      value: 'One-time donation',
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Long-term donation'),
                      value: 'Long-term donation',
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                  ],
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
                                          int.tryParse(
                                                  _durationController.text) ==
                                              0) {
                                        return 'This field is required.';
                                      } else if (int.tryParse(
                                              _durationController.text) ==
                                          null) {
                                        return 'It should be a valid number.';
                                      } else if (int.parse(
                                              _durationController.text) >
                                          1000) {
                                        return 'It cannot be greater than 1000.';
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
                                    validator: (value) =>
                                        _validateDuration(_selectedDuration),
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
                Text('Donation Details'),
                TextFormField(
                  controller: _recipientDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter donation details',
                  ),
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                'You have successfully donated!',
                              ), // Your message here
                            ));
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
