import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_sembako/models/api_response.dart';
import 'package:toko_sembako/screens/login.dart';
import 'package:toko_sembako/services/user_service.dart';

import '../constant.dart';
import '../models/user.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController
  nameController = TextEditingController(),
  emailController = TextEditingController(),
  passwordController = TextEditingController(),
  passwordConfirmController = TextEditingController();
  bool loading = false;

  void _registerUser () async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading =false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) => value!.isEmpty ? 'Invalid Name' : null,
              decoration: kInputDecoration('Name')
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Invalid EMail Address' : null,
              decoration: kInputDecoration('Email')
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              validator: (value) => value!.length < 6 ? 'Required at least 6 chars' : null,
              decoration: kInputDecoration('Password')
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: passwordConfirmController,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              validator: (value) => value! != passwordController.text ? 'Confirm password does not match' : null,
              decoration: kInputDecoration('Confirm Password')
            ),
            SizedBox(height: 15,),
            loading? Center(
              child: CircularProgressIndicator(),
            ):
            kTextButton('Register', (){
              if (formkey.currentState!.validate()) {
                setState(() {
                  loading = true;
                  _registerUser();
                });
              }
            }),
            SizedBox(height: 15,),
            kLoginRegisterHint('Do You have an account?','Login', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route) => false);
            }),
          ],
        ),
      ),
    );
  }
}