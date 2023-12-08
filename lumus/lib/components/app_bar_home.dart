import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

class HomeAppBar{
  static AppBar appBar(){
    return AppBar(
      actions: [
        IconButton(
          onPressed: signUserOut, 
          icon: Icon(
            Icons.power_settings_new,
            size: 30,
          )
        ),
      ],
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      // bottom: TabBar(
      //   indicatorColor: Color.fromRGBO(240, 240, 240, 1),
      //   unselectedLabelStyle: GoogleFonts.dmSans(
      //                 color: Color.fromRGBO(240, 240, 240, 1),
      //                 fontSize: 16,
      //               ),
      //   labelStyle: GoogleFonts.dmSans(
      //                 color: Color.fromRGBO(240, 240, 240, 1),
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.bold
      //               ),
      //   tabs: [
      //     Tab(
      //       child: Text(
      //         'Geral',
      //       ),
      //     ),
      //     Tab(
      //       child: Text(
      //         'Seguindo',
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
