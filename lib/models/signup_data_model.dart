import 'dart:io';

import 'country_model.dart';
class SignupDataModel{
  final String? name;
  final String ?email;
  final String? password;
  final String ?type;
  final String? phone;
   String? otp;
  File ?image;
  CountryModel? country;
  String ?dob;
  SignupDataModel({this.type,this.phone,this.name,this.email,this.password,this.otp,this.image,this.country,this.dob});
}