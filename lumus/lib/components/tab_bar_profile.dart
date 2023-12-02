import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabFilterProfileContentBar extends StatelessWidget {
  const MyTabFilterProfileContentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, 
      child: TabBar(
        onTap: (selectedTabIndex) {},
        isScrollable: true,
        indicatorColor: Color.fromRGBO(240, 240, 240, 1),
        tabs: [
          Tab(
            child: Text(
              "Favoritos",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Posts",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Reviews",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Assistidos",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Curtidos",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Listas",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}