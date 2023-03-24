import 'package:flutter/material.dart';
import 'package:nrs2023/screens/register.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Register();
  }
}
