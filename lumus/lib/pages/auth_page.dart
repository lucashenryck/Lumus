import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumus/auth/login_or_register.dart';
import 'package:lumus/components/bottom_navigation_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User is logged in
          if(snapshot.hasData){
            return Navigation();
          }

          //User is NOT logged in
          else{
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}