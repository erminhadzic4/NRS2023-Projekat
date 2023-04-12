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
        title: const Text('Home Screen'),
      ),
      body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
                    builder: (context) => const PaymentPage(
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
