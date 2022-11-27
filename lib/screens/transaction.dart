import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:toko_sembako/constant.dart';

import '../models/api_response.dart';
import '../models/trans.dart';
import '../services/trans_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<dynamic> _transactionList =[];
  int userId = 0;
  bool _loading = false;

  //get all transaction
  Future<void> retrieveTransactions() async {
    userId = await getUserId();
    ApiResponse response = await getTransaction();

    if(response.error == null){
      setState(() {
        _transactionList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? Center(
      child: CircularProgressIndicator(),
    ):
    ListView.builder(
      itemCount: _transactionList.length,
      itemBuilder: (BuildContext context, int index){
        Trans trans = _transactionList[index];
        return Text('${trans.nameCustomer}');
      },
    );
  }
}