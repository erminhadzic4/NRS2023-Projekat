import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;

  void setToken(String value) {
    _token = value;
    notifyListeners();
  }
}