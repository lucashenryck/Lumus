import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeAppBar{
  static AppBar appBar(){
    return AppBar(
      actions: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(3.141),
          child: IconButton(
            onPressed: (){}, 
            icon: Icon(CupertinoIcons.ellipses_bubble),
          ),
        )
      ],
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text(
              'Geral',
              style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Tab(
            child: Text(
              'Seguindo',
              style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
