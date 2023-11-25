import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/follow_numbers.dart';
import 'package:lumus/components/statistics_user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent()
        ],
      )
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight/2;
    final bottom = profileHeight/2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage()
        ),
        Positioned(
          top: top,
          child: buildProfileImage()
        ),
      ],
    );
  }

  Widget buildContent() => Column(
    children: [
      const SizedBox(height: 8),
      Text(
        'name',
        style: GoogleFonts.dmSans(
          color: Color.fromRGBO(240, 240, 240, 1),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        '@username',
        style: GoogleFonts.dmSans(
          color: Color.fromRGBO(240, 240, 240, 1),
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 16),
      NumberWidget(),
      const SizedBox(height: 8),
      Divider(color: Color.fromRGBO(240, 240, 240, 1)),
      const SizedBox(height: 8),
      MyStatistics(),
      const SizedBox(height: 8),
      Divider(color: Color.fromRGBO(240, 240, 240, 1)),
      const SizedBox(height: 8),
      Text(
        'Sobre você',
        style: GoogleFonts.dmSans(
          color: Color.fromRGBO(240, 240, 240, 1),
          fontSize: 25,
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Text(
          'All things fade. All things. Flesh, stone, even stars themselves. Time takes all things. It is the way of the world. The past recedes, memories fade, and so, true, does the spirit. Everything yields to time, even the soul.',
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 15,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    ],
  );

  Widget buildCoverImage() => Container(
    color: Color.fromRGBO(79, 112, 156, 1),
    child: Image.network(
      'https://i.pinimg.com/originals/20/99/36/20993641505ad625eef50fc46a2a4f72.png',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight/2,
    backgroundColor: Colors.grey,
    backgroundImage: NetworkImage(
      'https://media.gazetadopovo.com.br/2009/02/83ef48980ae24757ad4879674c61643e-gpLarge.jpg'
    ),
  );
}