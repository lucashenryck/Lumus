import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumus/constants.dart';

class Favorites extends StatelessWidget {
  final String userUid;
  const Favorites({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users collections')
              .doc(userUid)
              .collection('Favorites')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            var favoritesList = snapshot.data?.docs;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: favoritesList?.length,
              itemBuilder: (context, index) {
                String posterPath = favoritesList![index]['poster_path'];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 0.25, 
                      ),
                    ),
                    height: 160,
                    width: 100,
                    child: Image.network(
                      '${Constants.imagePath}$posterPath',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}