import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumus/components/my_list_tile.dart';
import 'package:lumus/pages/profile_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key,});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //Sign user out method
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  //Navigate to profile page
  void goToProfilePage(){
    //Pop menu drawer
    Navigator.pop(context);

    //Go to profile page
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => MyProfile(userUid: FirebaseAuth.instance.currentUser!.uid)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //Preview user icon and information
                DrawerHeader(
                  child: Icon(
                    Icons.person,
                    color: Color.fromRGBO(240, 240, 240, 1),
                    size: 70,
                  ),
                ),
    
                //My reviews
                MyListTile(
                  icon: Icons.reviews, 
                  text: 'Reviews', 
                  onTap: () => Navigator.pop(context),
                ),
    
                //My lists
                MyListTile(
                  icon: Icons.list, 
                  text: 'Listas', 
                  onTap: () => Navigator.pop(context),
                ),
    
                //My Watchlist
                MyListTile(
                  icon: Icons.watch_later_outlined, 
                  text: 'Watchlist', 
                  onTap: () => Navigator.pop(context),
                ),
    
                //Activity
                MyListTile(
                  icon: Icons.timeline, 
                  text: 'Atividade', 
                  onTap: () => Navigator.pop(context),
                ),
    
                //Settings
                MyListTile(
                  icon: Icons.settings, 
                  text: 'Configurações', 
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
    
            //Sign out
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: MyListTile(
                icon: Icons.logout, 
                text: 'Sair', 
                onTap: signUserOut,
              ),
            )
          ],
        ),
      ),
    );
  }
}