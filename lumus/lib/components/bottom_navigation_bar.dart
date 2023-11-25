import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumus/pages/create/create_post_or_review_page.dart';
import 'package:lumus/pages/home_page.dart';
import 'package:lumus/pages/notifications.dart';
import 'package:lumus/pages/profile_page.dart';
import 'package:lumus/pages/search_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  final List<Widget> telas = [
    const HomePage(),
    const SearchPage(),
    const CreatePostOrReviewPage(),
    const NotificationsPage(),
    const MyProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: telas,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        hoverElevation: 10,
        elevation: 4,
        child: const Icon(
          CupertinoIcons.add,
          color: Color.fromRGBO(19, 32, 67, 1),
          size: 35,
        ),
        onPressed: () => setState(() {
          currentIndex = 2;
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(19, 32, 67, 1),
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
            icon: SizedBox.shrink(), // Empty icon for the center button
            label: '',
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