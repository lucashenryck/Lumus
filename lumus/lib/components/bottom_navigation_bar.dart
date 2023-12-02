import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumus/pages/create/create_post.dart';
import 'package:lumus/pages/home_page.dart';
import 'package:lumus/pages/notifications.dart';
import 'package:lumus/pages/profile_page.dart';
import 'package:lumus/pages/search_page.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

   @override 
  void initState(){
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserLumus();
  }

  final List<Widget> telas = [
    const HomePage(),
    const SearchPage(),
    const NotificationsPage(),
    MyProfile(userUid: FirebaseAuth.instance.currentUser!.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: telas,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        hoverElevation: 10,
        elevation: 30,
        child: const Icon(
          CupertinoIcons.add,
          color: Color.fromRGBO(3, 21, 37, 1),
          size: 40,
        ),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePost()
            )
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        selectedItemColor: Color.fromRGBO(240, 240, 240, 1),
        unselectedItemColor: Color.fromRGBO(240, 240, 240, 1),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search_circle, size: 35),
            activeIcon: Icon(CupertinoIcons.search_circle_fill, size: 35),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            activeIcon: Icon(CupertinoIcons.bell_fill),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}