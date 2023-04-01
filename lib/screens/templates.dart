import 'package:flutter/material.dart';

class Payment {
  TextEditingController Currency = TextEditingController();
  TextEditingController? Amount = TextEditingController();
  TextEditingController? RecipientName = TextEditingController();
  TextEditingController? RecipientAccount = TextEditingController();

  Payment({
    required this.Currency,
    required this.Amount,
    required this.RecipientName,
    required this.RecipientAccount,
  });
}

class TemplatesPage extends StatefulWidget {
  @override
  _TemplatesPageState createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  List<Payment> templates = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController =
  TextEditingController();
  final TextEditingController _recipientAccountController =
  TextEditingController();
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
  /*void _addTemplate() {
    if (_formKey.currentState!.validate()) {
      Payment template = Payment(
        Currency: _currencyController,
        Amount: _amountController.text.isEmpty
            ? null
            : _amountController, // make it nullable if the user left it empty
        RecipientName: _recipientNameController,
        RecipientAccount: _recipientAccountController,
      );
      setState(() {
        templates.add(template);
      });
      _currencyController.clear();
      _amountController.clear();
      _recipientNameController.clear();
      _recipientAccountController.clear();
    }
  }
*/
  @override
  void dispose() {
    _currencyController.dispose();
    _amountController.dispose();
    _recipientNameController.dispose();
    _recipientAccountController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Templates'),
      ), body: ListView.builder(
      itemCount: templates.length,
      itemBuilder: (BuildContext context, int index) {
        if (templates.length != 0) {
          return ListTile(
            title: Text(
                templates[index].RecipientName!.text.toString()),
            subtitle: Text(
                templates[index].Amount?.text.toString() ?? 'N/A'),
          );
        }
      },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
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
                          decoration: InputDecoration(labelText: 'Amount'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _recipientNameController,
                          decoration: InputDecoration(labelText: 'Recipient name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter recipient name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _recipientAccountController,
                          decoration: InputDecoration(labelText: 'Recipient account'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter recipient account';
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
                          Payment newPayment = Payment(
                              Currency: _currencyController,
                              Amount: _amountController,
                              RecipientName: _recipientNameController,
                              RecipientAccount: _recipientAccountController);
                          setState(() {
                            templates.add(newPayment);
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}