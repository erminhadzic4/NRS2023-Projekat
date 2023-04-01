import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactions.dart';

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
  RangeValues _currentRangeValues = const RangeValues(0, 10000);
  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
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
            child: Column(children: <Widget>[
              RangeSlider(
                min: 0,
                max: 10000,
                values: _currentRangeValues,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              Text(
                _currentRangeValues.start.toInt().toString() +
                    ' - ' +
                    _currentRangeValues.end.toInt().toString() +
                    ' ' +
                    _selectedCurrency,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ]),
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
          Expanded(
            child: Container(),
          ),
          Flexible(
            child: DropdownButtonFormField<String>(
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
                        child: Text(
                          currency,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ]),
        ElevatedButton(
          child: const Text("Apply Filters"),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Transactions()),
            );
          },
        ),
      ]),
    );
  }
}
