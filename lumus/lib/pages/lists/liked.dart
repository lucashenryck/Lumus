import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/constants.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({super.key, required this.userId});
  final String userId;

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  late Stream<QuerySnapshot> _likedStream;

  @override
  void initState() {
    super.initState();
    _likedStream = FirebaseFirestore.instance
        .collection('Users collections')
        .doc(widget.userId)
        .collection('Liked')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: Text(
          'Curtidos',
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 18,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _likedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum filme ou série curtido',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 15,
                ),
              ),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(right: 8, left: 8, top: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 120
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String posterPath = data['poster_path'] ?? '';
                return GridTile(
                  child: Container(
                    child: Image.network(
                      '${Constants.imagePath}$posterPath',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5, 
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}