import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/follow_button.dart';
import 'package:lumus/components/follow_numbers.dart';
import 'package:lumus/components/tab_bar_profile.dart';
import 'package:lumus/pages/edit_page.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfile extends StatefulWidget {
  final String userUid;
  const MyProfile({super.key, required this.userUid});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int followers = 0;
  int following = 0;
  final double profileHeight = 125;
  var userData = {};
  bool isFollowing = false;

  void errorAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.error,
      text: "Algo de errado ocorreu!",
      title: "Erro!",
      confirmBtnText: "Continuar"
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    try{
      var userSnap = await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.userUid)
      .get();

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

      userData = userSnap.data()!;
      setState(() {
        
      });
    } catch (e) {  
      errorAlert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(userData['username']),
            floating: false,
            pinned: true,
            centerTitle: false,
            backgroundColor: Color.fromRGBO(3, 21, 37, 1),
            leading: IconButton(
              onPressed: (){
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage()
                    )
                  );
                }, 
                icon: Icon(Icons.edit, size: 30
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildProfileImage(),
              buildContent()
            ]),
          ),
        ],
      )
    );
  }
  
  Widget buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 10),
      Column(
        children: [
          Column(
            children: [
              if (FirebaseAuth.instance.currentUser!.uid == widget.userUid)
              Text(
                userData['username'],
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (FirebaseAuth.instance.currentUser!.uid == widget.userUid)
              FollowButton(
                text: isFollowing ? "Seguindo" : "Seguir",
                backgroundColor: isFollowing ? 
                const Color.fromRGBO(3, 21, 37, 1) 
                : const Color.fromRGBO(240, 240, 240, 1),
                textColor: isFollowing ?
                Color.fromRGBO(240, 240, 240, 1) : 
                const Color.fromRGBO(3, 21, 37, 1),
                borderColor: Color.fromRGBO(240, 240, 240, 1),
                function: (){},
              ),
            ],
          ),
        ],
      ),
      NumberWidget(followers: followers, following: following,),
      const SizedBox(height: 8),
      Visibility(
        visible: userData['description'] != null,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Text(
            userData['description'] ?? 'No description available', // Use the null-aware operator to provide a default value
            style: GoogleFonts.dmSans(
              color: Color.fromRGBO(240, 240, 240, 1),
              fontSize: 15,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Divider(
        color: Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const MyTabFilterProfileContentBar()
    ],
  );

  Widget buildProfileImage() => CircleAvatar(
  radius: profileHeight / 2,
  backgroundColor: Color.fromRGBO(240, 240, 240, 1),
  child: ClipOval(
    child: Image.network(
      userData['profile_photo'] ?? "https://static.thenounproject.com/png/354384-200.png",
      fit: BoxFit.cover, 
      width: profileHeight,
      height: profileHeight,
    ),
  ),
);
}