import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactions.dart';

String _selectedCurrency = "All";
final List<String> _currencies = [
  'All',
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

class FiltersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool? _isCheckedDeposit = true;
  bool? _isCheckedWithdrawal = true;
  TextEditingController _textEditingController1 =
      TextEditingController(text: '0');
  TextEditingController _textEditingController2 =
      TextEditingController(text: '10000');
  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.utc(1900, 1, 1), end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Text(
            'Price Range:',
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textEditingController1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Text(
                    ' - ',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _textEditingController2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        Row(children: <Widget>[
          Text(
            'Transaction Type:',
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          Expanded(
            child: Column(children: <Widget>[
              CheckboxListTile(
                title: const Text('Deposits'),
                value: _isCheckedDeposit,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isCheckedDeposit = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('Withdrawals'),
                value: _isCheckedWithdrawal,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isCheckedWithdrawal = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ]),
          ),
        ]),
        Row(children: <Widget>[
          Text(
            'Date Range:',
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          Expanded(
            child: Column(children: <Widget>[
              ElevatedButton(
                child: const Text("Select Date Range"),
                onPressed: () async {
                  final DateTimeRange? dateTimeRange =
                      await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (dateTimeRange != null) {
                    setState(() {
                      selectedDates = dateTimeRange;
                    });
                  }
                },
              ),
              Text(
                selectedDates.start.day.toString() +
                    "/" +
                    selectedDates.start.month.toString() +
                    "/" +
                    selectedDates.start.year.toString() +
                    " - " +
                    selectedDates.end.day.toString() +
                    "/" +
                    selectedDates.end.month.toString() +
                    "/" +
                    selectedDates.end.year.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ]),
          ),
        ]),
        Row(children: <Widget>[
          Text(
            'Selected Currency:',
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          Flexible(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
              ),
              value: _selectedCurrency,
              onChanged: (String? value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
              items: _currencies
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Center(
                          child: Text(
                            currency,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ]),
        ElevatedButton(
          child: const Text("Apply Filters"),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Transactions(
                        filterDateStart: selectedDates.start,
                        filterDateEnd: selectedDates.end,
                        filterCurrency: _selectedCurrency,
                        filterPriceRangeStart:
                            (double.parse(_textEditingController1.text)),
                        filterPriceRangeEnd:
                            (double.parse(_textEditingController2.text)),
                        filterDepositsTrue: _isCheckedDeposit,
                        filterWithdrawalsTrue: _isCheckedWithdrawal,
                      )),
            );
          },
        ),
      ]),
    );
  }
}
