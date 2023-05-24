import 'package:flutter/material.dart';
import 'package:nrs2023/screens/home.dart';
import 'package:nrs2023/screens/register.dart';

import 'logIn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100.0,
              child: Image.asset('res/img/logo2.png'),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Welcome to the PayPal application!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              'To get started with PayPal transactions, please choose to register or login.',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Montserrat',
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              key: const ValueKey('logInButton'), // Add a key to the button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const logIn()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900],
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 5.0,
                animationDuration: const Duration(milliseconds: 300),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.blue[900] ?? Colors.white,
                  width: 2.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                animationDuration: const Duration(milliseconds: 300),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: SizedBox(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Need support help? ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[700],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // trenutni nacin za odlazak na HomeScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text(
                        'Contact us',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
