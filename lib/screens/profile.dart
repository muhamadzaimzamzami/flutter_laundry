import 'dart:io';

import 'package:toko_sembako/models/api_response.dart';
import 'package:toko_sembako/models/user.dart';
import 'package:toko_sembako/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtNameController = TextEditingController();


  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if(response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  //update profile
  void updateProfile() async {
    ApiResponse response = await updateUser(txtNameController.text);
      setState(() {
        loading = false;
      });
    if(response.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.data}')
      ));
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),) :
    Padding(
      padding: EdgeInsets.only(top: 40, left: 40, right: 40),
      child: ListView(
        children: [
          Center(
            child:GestureDetector(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image:  DecorationImage(
                    image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                    fit: BoxFit.cover
                  ),
                  color: Colors.amber
                ),
              ),
              onTap: (){
                
              },
            )
          ),
          SizedBox(height: 20,),
          Form(
            key: formKey,
            child: TextFormField(
              decoration: kInputDecoration('Name'),
              controller: txtNameController,
              validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
            ),
          ),
          SizedBox(height: 20,),
          kTextButton('Update', (){
            if(formKey.currentState!.validate()){
              setState(() {
                loading = true;
              });
              updateProfile();
            }
          })
        ],
      ),
    );
  }
}