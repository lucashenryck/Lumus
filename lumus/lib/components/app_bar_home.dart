import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
            selectedIcon: Icon(CupertinoIcons.ellipses_bubble_fill),
          ),
        )
      ],
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text(
              'Geral',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromRGBO(240, 240, 240, 1)
              ),
            ),
          ),
          Tab(
            child: Text(
              'Seguindo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromRGBO(240, 240, 240, 1)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
