import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/services.dart';

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
  'c2c',
  'c2b',
  'b2b',
];

class FiltersScreen extends StatefulWidget {
  late TextEditingController textEditingController1 =
      TextEditingController(text: '0');
  late TextEditingController textEditingController2 =
      TextEditingController(text: '100000');
  late TextEditingController textEditingController3 =
      TextEditingController(text: '');
  late TextEditingController textEditingController4 =
      TextEditingController(text: '');
  late TextEditingController textEditingController5 =
      TextEditingController(text: '');
  late TextEditingController textEditingController6 =
      TextEditingController(text: '');
  late DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.utc(1900, 1, 1), end: DateTime.now());
  late String selectedCurrency = "All";
  late String selectedTransactionType = "All";
  late String selectedFilterSortingOrder = "createdAtAsc";

  FiltersScreen(
      {required this.textEditingController1,
      required this.textEditingController2,
      required this.textEditingController3,
      required this.textEditingController4,
      required this.textEditingController5,
      required this.textEditingController6,
      required this.selectedDates,
      required this.selectedCurrency,
      required this.selectedTransactionType,
      required this.selectedFilterSortingOrder});
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text(
              'Price Range: ',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        key: const ValueKey('priceRangeStart'),
                        keyboardType: TextInputType.number,
                        enableInteractiveSelection: false,
                        controller: widget.textEditingController1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        ' - ',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        key: const ValueKey('priceRangeEnd'),
                        keyboardType: TextInputType.number,
                        enableInteractiveSelection: false,
                        controller: widget.textEditingController2,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
          Row(
            children: <Widget>[
              Text(
                "Recipient's Name: ",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Expanded(
                child: TextFormField(
                  key: const ValueKey('recipientsName'),
                  controller: widget.textEditingController3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "Recipient's Account: ",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Expanded(
                child: TextFormField(
                  key: const ValueKey('recipientsAccount'),
                  keyboardType: TextInputType.text,
                  controller: widget.textEditingController4,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "Sender's Name: ",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Expanded(
                child: TextFormField(
                  key: const ValueKey('sendersName'),
                  controller: widget.textEditingController5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          Row(children: <Widget>[
            Text(
              'Transaction Type:',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                key: const ValueKey('transactionTypeDropdown'),
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
              'Date Range:',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Expanded(
              child: Column(children: <Widget>[
                ElevatedButton(
                  key: const ValueKey('selectDateButton'),
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
                        widget.selectedDates = dateTimeRange;
                      });
                    }
                  },
                ),
                if (widget.selectedDates != null)
                  Text(
                    intl.DateFormat.yMMMMd('en_US')
                            .format(widget.selectedDates.start) +
                        ' - ' +
                        intl.DateFormat.yMMMMd('en_US')
                            .format(widget.selectedDates.end),
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
                key: const ValueKey('selectCurrencyDropdown'),
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
          Row(
            children: <Widget>[
              Text(
                "Category: ",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Expanded(
                child: TextFormField(
                  key: const ValueKey('category'),
                  controller: widget.textEditingController6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          ElevatedButton(
            child: const Text("Apply Filters"),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Transactions(
                        filterDateStart: widget.selectedDates.start,
                        filterDateEnd: widget.selectedDates.end,
                        filterCurrency: widget.selectedCurrency,
                        filterPriceRangeStart:
                            widget.textEditingController1.text,
                        filterPriceRangeEnd: widget.textEditingController2.text,
                        filterRecipientName: widget.textEditingController3.text,
                        filterRecipientAccount:
                            widget.textEditingController4.text,
                        filterSenderName: widget.textEditingController5.text,
                        filterCategory: widget.textEditingController6.text,
                        filterTransactionType: widget.selectedTransactionType,
                        filterSortingOrder: widget.selectedFilterSortingOrder)),
              );
            },
          ),
        ]),
      ),
    );
  }
}
