import 'package:flutter/material.dart';
import 'package:nrs2023/screens/loginAuth.dart';
import 'package:nrs2023/screens/numberValidation.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:nrs2023/screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
