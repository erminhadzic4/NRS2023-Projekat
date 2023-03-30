import 'dart:ffi';

import 'package:flutter/material.dart';

class Payment {
  TextEditingController Currency;
  TextEditingController? Amount;
  TextEditingController? RecipientName;
  TextEditingController? RecipientAccount;

  Payment(
      {required this.Currency,
      required this.Amount,
      required this.RecipientName,
      required this.RecipientAccount});
}

class TemplatesPage extends StatefulWidget {
  @override
  _TemplatesPageState createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  List<Payment> templates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Templates'),
      ),
      // body: ListView.builder(
      //   itemCount: templates.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     if (templates.length != 0) {
      //       return ListTile(
      //         title: Text(templates[index].RecipientName.text.toString()),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
