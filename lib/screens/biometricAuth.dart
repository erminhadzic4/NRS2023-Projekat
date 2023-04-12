import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<BiometricAuthentication> createState() => BiometricAuthenticationState();
}

class BiometricAuthenticationState extends State<BiometricAuthentication> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
        (bool isSupported) => setState(() {
          _supportState = isSupported;
        })
    );
  }

  Future<void> getSupportedBios() async{
    List<BiometricType> avalibleBios = await auth.getAvailableBiometrics();
  print(avalibleBios);
  if(!mounted) {
    return;
  }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> authenticate() async {
    final isAvalible = await hasBiometrics();
    if(!isAvalible) {
      return false;
    }
    try {
      return await auth.authenticate(
          localizedReason: "Authenticate yourself with either fingerprint or face recognition",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          )
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Biometrics Login",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Image.asset(
                    "res/img/fingerprint.jpg",
                    width: 140.0,
                  ),
                /*  Text(
                    "Fingerprint Auth",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,

                    ),
                  ),*/
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: const Text(
                      "Authenticate using your fingerprint",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    width: 400,
                    child: ElevatedButton(
                        onPressed: authenticate,
                        child: Text("Authenticate", style: TextStyle(color: Colors.white,
                            fontSize: 20.0),
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*
@override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        title: Text('Biometrics auth')
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: getSupportedBios,
              child: Text("get supported biometrics")
          ),
          ElevatedButton(
              onPressed: authenticate,
              child: Text("authenticate")
          )
        ],
      ),
    );
  }
}
*/
