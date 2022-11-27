import 'user.dart';

class Trans{
  int? id;
  User? user;
  String? nameCustomer;
  String? phone;
  String? address;
  double? weight;
  String? paket;
  double? total;
  String? status;

  Trans({
    this.id,
    this.user,
    this.nameCustomer,
    this.phone,
    this.address,
    this.weight,
    this.paket,
    this.total,
    this.status,
  });

  //function to convert json data to user model
  factory Trans.fromJson(Map<String, dynamic> json){
    return Trans(
      id: json['id'],
      nameCustomer: json['nameCustomer'],
      phone: json['phone'],
      address: json['address'],
      weight: json['weight'],
      paket: json['paket'],
      total: json['total'],
      status: json['status'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
      ),
      
    );
  }
}