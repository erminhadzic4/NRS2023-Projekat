
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';


class AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text.replaceAll('-', '');
    String formattedValue = '';
    for (int i = 0; i < value.length; i++) {
      formattedValue += value[i];
      if ((i + 1) % 4 == 0 && i != value.length - 1) {
        formattedValue += '-';
      }
    }
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class accountCreation extends StatefulWidget {
  const accountCreation({Key? key}) : super(key: key);

  @override
  State<accountCreation> createState() => accountCreationState();
}

class accountCreationState extends State<accountCreation> {
  final List<String> currencies = [     //slanje na backend rade samo BAM, USD, EUR, CHF
    'USD',
    'AUD',
    'BRL',
    'CAD',
    'CHF',
    'CZK',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'HUF',
    'ILS',
    'JPY',
    'MXN',
    'NOK',
    'NZD',
    'PHP',
    'PLN',
    'RUB',
    'SEK',
    'SGD',
    'THB',
    'TWD'
  ];

  bool isLoading = false;

  late FilePickerResult? result;
  late String? fileName = "";
  late String? filePath = "";
  late PlatformFile? pickedFile;
  final storage = new FlutterSecureStorage();

  String selectedCurrency = "USD";

  final descController = TextEditingController();



  Future getId() async {
    String? token = await storage.read(key: 'token');
    final res = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    var responseData = jsonDecode(res.body);
    var usrname = responseData['userName'].toString();
    final res1 = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/User/$usrname"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    var responseData1 = jsonDecode(res1.body);
    var userId = responseData1['id'].toString();

    return userId;
  }

  Future getCurrencyId() async {
    String? token = await storage.read(key: 'token');
    final res = await http.get(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/ExchangeRate/currency"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    var responseData = jsonDecode(res.body);
    for(var currency in responseData) {
      if(currency['name'] == selectedCurrency) {
        return currency['id'].toString();
      }
    }

  }

  void uploadFile() async {
    final permissionStatus = await Permission.storage.status;
      await Permission.storage.request();
      try{
        setState(() {
          isLoading = true;
        });
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false
        );

        if(result!=null) {
          fileName = result!.files.first.name;
          pickedFile = result!.files.first;
          filePath = result!.files.first.path;
          //return _result!.files.first.name;
          print("SELECTED FILE: $filePath");
        }
        setState(() {
          isLoading = false;
        });
      }
      catch(e) {
        print(e);
    }
  }

  Future<void> accountCreationRequest() async {
    var userId = await getId();
    //print("USERID: $userId");      ////HVATA SE I PRINTA USERID OK!

    var currencyId = await getCurrencyId();
    //print("CURRENCYID: $currencyId");

    String? token = await storage.read(key: 'token');


    final res = await http.post(
        Uri.parse("http://siprojekat.duckdns.org:5051/api/Account/user-account-create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "currencyId": "$currencyId",
          "description": descController.text,  //staviti controller
          "requestDocumentPath": filePath.toString(),  //
          "userId": "$userId"
        }));
    var response = json.decode(res.body);
    //print(response.toString());
    print(res.statusCode);

    if ((res.statusCode == 200) && context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Request successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failure'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Request failed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Account Creation"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80),

              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 350,
                  child: Text('Currency'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField<String>(
                  value: selectedCurrency,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCurrency = value!;
                    });
                  },
                  items: currencies
                      .map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  ))
                      .toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 350,
                  child: Text('Account information'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                          AccountNumberFormatter(),
                          LengthLimitingTextInputFormatter(19),
                        ],
                        //controller: _controllers[0],
                        onFieldSubmitted: (String value) {
                          //FocusScope.of(context).requestFocus(_focusInput[0]);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 350,
                  child: Text('Description'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: descController,
                        /*autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                        },*/
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: accountCreationRequest,
                  child: Text("SUBMIT")
              ),
              ElevatedButton(
                  onPressed: uploadFile,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("UPLOAD FILE"),
                        Icon(
                          Icons.file_upload,
                          size: 30.0,
                        )
                      ]
                      )
              ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Column(children: [
                    Text("$fileName"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(onPressed: () {
                      setState(() {
                        fileName = "";
                        filePath = null;
                        print(filePath);
                      });
                    },
                        child: Text("Remove file"))
                  ])
                  ) ,




            ],
          ),
        ),
      ),
    );;
  }
}
