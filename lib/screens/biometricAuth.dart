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
