import 'package:flutter/material.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/login.dart';
import 'package:nrs2023/screens/transactions.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                child: MaterialButton(
                  elevation: 10,
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => logIn()),
                    );
                  },
                  color: Colors.blue,
                  child: const Text("Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(
                          templateData: ["", "", "", ""],
                          recipientName: '',
                          recipientAccount: '',
                          amount: '',
                          currency: '',

                        )),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Transactions(
                          filterDateStart: DateTime.utc(1900, 1, 1),
                          filterDateEnd: DateTime.now(),
                          filterCurrency: 'All',
                          filterPriceRangeStart: 0,
                          filterPriceRangeEnd: 100000,
                          filterDepositsTrue: true,
                          filterWithdrawalsTrue: true,
                        )),
              );
              break;
          }
        },
      ),
    );
  }
}
