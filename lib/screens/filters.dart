import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:intl/intl.dart' as intl;

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

final List<String> _TransactionTypes = [
  'All',
  'Withdrawal',
  'Deposit',
  'Send',
  'Receive'
];

class FiltersScreen extends StatefulWidget {
  late bool? isCheckedDeposit = true;
  late bool? isCheckedWithdrawal = true;
  late TextEditingController textEditingController1 =
      TextEditingController(text: '0');
  late TextEditingController textEditingController2 =
      TextEditingController(text: '100000');
  late DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.utc(1900, 1, 1), end: DateTime.now());
  late DateTime? selectedDate = (DateTime.now());
  late String selectedCurrency = "All";
  late String selectedTransactionType = "All";

  FiltersScreen(
      {required this.isCheckedDeposit,
      required this.isCheckedWithdrawal,
      required this.textEditingController1,
      required this.textEditingController2,
      required this.selectedDates,
      required this.selectedDate,
      required this.selectedCurrency,
      required this.selectedTransactionType});
  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text(
              'Price:',
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
                        keyboardType: TextInputType.number,
                        enableInteractiveSelection: false,
                        controller: widget.textEditingController1,
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
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                ),
                value: widget.selectedTransactionType,
                onChanged: (String? value) {
                  setState(() {
                    widget.selectedTransactionType = value!;
                  });
                },
                items:
                    _TransactionTypes.map((transactiontype) => DropdownMenuItem(
                          value: transactiontype,
                          child: Center(
                            child: Text(
                              transactiontype,
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        )).toList(),
              ),
            ),
          ]),
          Row(children: <Widget>[
            Text(
              'Date:',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Expanded(
              child: Column(children: <Widget>[
                ElevatedButton(
                  child: const Text("Select Date"),
                  onPressed: () async {
                    DateTime? dateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                        initialDate: DateTime(2023));
                    if (DateTime != null) {
                      setState(() {
                        widget.selectedDate = dateTime;
                      });
                    }
                  },
                ),
                if (widget.selectedDate != null)
                  Text(
                    intl.DateFormat.yMMMMd('en_US')
                        .format(widget.selectedDate!),
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
                value: widget.selectedCurrency,
                onChanged: (String? value) {
                  setState(() {
                    widget.selectedCurrency = value!;
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Transactions(
                          filterDateStart: widget.selectedDates.start,
                          filterDateEnd: widget.selectedDates.end,
                          filterDate: widget.selectedDate,
                          filterCurrency: widget.selectedCurrency,
                          filterPriceRangeStart: (double.parse(
                              widget.textEditingController1.text)),
                          filterPriceRangeEnd: (double.parse(
                              widget.textEditingController2.text)),
                          filterDepositsTrue: widget.isCheckedDeposit,
                          filterWithdrawalsTrue: widget.isCheckedWithdrawal,
                          filterTransactionType: widget.selectedTransactionType,
                        )),
              );
            },
          ),
        ]),
      ),
    );
  }
}
