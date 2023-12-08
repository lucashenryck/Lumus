import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumus/components/like_button.dart';
import 'package:lumus/resources/firestore_methods.dart';

class PostUI extends StatefulWidget {
  final DocumentSnapshot post;

  const PostUI({
    super.key,
    required this.post
  });

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  late Map<String, dynamic> post;

  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    post = widget.post.data() as Map<String, dynamic>;
    isLiked = post['likes'].contains(currentUser!.uid);
  }

  void toggleLike() async{
    final currentUserUid = currentUser!.uid;
    final postId = post['post_id'];
    setState(() {
      isLiked = !isLiked;
    });
    try {
      await FirestoreMethods().likePost(postId, currentUserUid, post['likes']);
    } catch (e) {
      print("Error updating likes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final timePublished = post['time_published'] as Timestamp;
    final dateTime = timePublished.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy  HH:mm').format(dateTime);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Posts').doc(post['post_id']).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Loading indicator while fetching data
        }
        final updatedPost = snapshot.data!.data() as Map<String, dynamic>;
        return Material(
          elevation: 60,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(3, 21, 37, 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8, right: 7),
                      child: CircleAvatar(
                        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                        backgroundImage: NetworkImage(post['profile_photo'] ?? 'https://static.thenounproject.com/png/354384-200.png'),
                        radius: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        updatedPost['username'],
                          style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                if (updatedPost['rating'] != null)
                const SizedBox(height: 8),
                if (updatedPost['rating'] != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: updatedPost['rating'].toDouble(),
                        minRating: 0,
                        unratedColor: Colors.black,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        updateOnDrag: true,
                        itemSize: 20,
                        ignoreGestures: true, 
                        onRatingUpdate: (double value) {},
                      ),
                    ],
                  ),
                ),
                if (updatedPost['title_and_year'] != null)
                const SizedBox(height: 8),
                if (updatedPost['title_and_year'] != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Text(
                        updatedPost['title_and_year'],
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(229, 210, 131, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                if (updatedPost['content'] != null)
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      updatedPost['content'],
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    textAlign: TextAlign.justify,
                    textScaleFactor: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 5),
                          child: Text(
                              formattedDate,
                              style: GoogleFonts.dmSans(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w200
                              ),
                            ),
                        ),
                        Row(
                          children: [
                            LikeButton(
                              isLiked: isLiked, 
                              onTap: toggleLike
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                updatedPost['likes'].length.toString(),
                                style: GoogleFonts.dmSans(
                                  color: updatedPost['likes'].contains(currentUser!.uid) ? Colors.redAccent : Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Color.fromRGBO(240, 240, 240, 1))
              ],
            ),
          ),
        );
      },
    );
  }
}