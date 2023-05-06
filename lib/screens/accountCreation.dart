
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';


class _AccountNumberFormatter extends TextInputFormatter {
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
  State<accountCreation> createState() => _accountCreationState();
}

class _accountCreationState extends State<accountCreation> {



  final List<String> _currencies = [
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

  late FilePickerResult? _result;
  late String? _fileName = "";
  late PlatformFile? pickedFile;


  Future<String> setFile() async {
    return _fileName.toString();
  }

  void uploadFile() async {
    final permissionStatus = await Permission.storage.status;
      await Permission.storage.request();
      try{
        setState(() {
          isLoading = true;
        });
        _result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false,

        );

        if(_result!=null) {
          _fileName = _result!.files.first.name;
          pickedFile = _result!.files.first;
          //return _result!.files.first.name;
          print("SELECTED FILE: $_fileName");
        }

        setState(() {
          isLoading = false;
        });
      }
      catch(e) {
        print(e);
    }
    //return "";

  /*try{

    _result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if(_result!=null) {
      _fileName = _result!.files.first.name;
      pickedFile = _result!.files.first;
    }
  }
  catch(e) {
    print(e);
  }*/
  }

  void accountCreationRequest() {
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
                'Request successful',
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
                  //value: _selectedCurrency,
                  onChanged: (String? value) {
                    /*setState(() {
                      _selectedCurrency = value!;
                    });*/
                  },
                  items: _currencies
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
                          _AccountNumberFormatter(),
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
                    Text("$_fileName"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(onPressed: () {
                      setState(() {
                        _fileName = "";
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
