import 'package:flutter/material.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/confirm_number.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Pay());
  }
}
