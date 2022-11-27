import 'package:flutter/material.dart';
import 'package:toko_sembako/services/trans_service.dart';
import 'dart:math';

import '../constant.dart';
import '../models/api_response.dart';
import '../services/user_service.dart';
import 'login.dart';

class PostTransaction extends StatefulWidget {
  const PostTransaction({super.key});

  @override
  State<PostTransaction> createState() => _PostTransactionState();
}

class _PostTransactionState extends State<PostTransaction> {
  bool loading = false;
  int _value = 1;
  double total = 0;
  double berat = 0;
  String paket = '';
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _nameCustomer = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _total = TextEditingController();

  void _createTransaction() async {
    ApiResponse response = await postTransaction(_nameCustomer.text, _phone.text, _address.text, _weight.text, paket , _total.text);

    if(response.error ==  null) {
      Navigator.of(context).pop();
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            Row(
              children: [
                Text('Data Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _nameCustomer,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('Customer Name')
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _phone,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('Phone')
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _address,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('Adress')
            ),
            SizedBox(height: 15,),
            SizedBox(height: 15,),
            SizedBox(height: 15,),
            Row(
              children: [
                Text('Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _weight,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('Weight')
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 1, 
                          groupValue: _value, 
                          onChanged: (value){
                            setState(() {
                              _value = value!;
                               paket = 'express' ;
                            });
                          },
                        ),
                        Text('Express')
                      ],
                    ),
                    
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 2, 
                          groupValue: _value, 
                          onChanged: (value){
                            setState(() {
                              setState(() {
                              _value = value!;
                               paket = 'express' ;
                            });
                            });
                          },
                        ),
                        Text('Fast')
                      ],
                    ),
                    
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 3, 
                          groupValue: _value, 
                          onChanged: (value){
                            setState(() {
                              setState(() {
                              _value = value!;
                               paket = 'express' ;
                            });
                            });
                          },
                        ),
                        Text('Reguler')
                      ],
                    ),
                    
                  ],
                ),
              ],
            ),
            SizedBox(height: 15,),
            Text('Total Price'),
            TextFormField(
              controller: _total,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('0')
            ),
            SizedBox(height: 15,),
            loading? Center(
              child: CircularProgressIndicator(),
            ):
            kTextButton('Save', (){
              if (formkey.currentState!.validate()) {
                setState(() {
                  loading = !loading;
                  _createTransaction();
                });
                
              }
            }),
          ],
        )
      ),
    );
  }
}