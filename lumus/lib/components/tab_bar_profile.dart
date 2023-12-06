import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabFilterProfileContentBar extends StatelessWidget {
  const MyTabFilterProfileContentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: TabBar(
        onTap: (selectedTabIndex) {},
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.symmetric(horizontal: 32),
        indicatorColor: Color.fromRGBO(240, 240, 240, 1),
        tabs: [
          Tab(
            child: Text(
              "Publicações",
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Tab(
            child: Text(
              "Avaliações",
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