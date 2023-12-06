import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeAppBar{
  static AppBar appBar(){
    return AppBar(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      bottom: TabBar(
        indicatorColor: Color.fromRGBO(240, 240, 240, 1),
        unselectedLabelStyle: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 16,
                    ),
        labelStyle: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
        tabs: [
          Tab(
            child: Text(
              'Geral',
            ),
          ),
          Tab(
            child: Text(
              'Seguindo',
            ),
          ),
        ],
      ),
    );
  }
}
