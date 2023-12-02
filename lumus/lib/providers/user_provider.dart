import 'package:flutter/material.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  UserLumus? _user;
  final AuthMethods _authMethods = AuthMethods();
  
  //aquiiiiiiiiiiiiiiiiiiiiiiii
  UserLumus get getUserLumus => _user!;

  Future<void> refreshUserLumus() async {
    UserLumus user = await _authMethods.getUserLumusDetails();
    _user = user;
    notifyListeners();
  } 
}