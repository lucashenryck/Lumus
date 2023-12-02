import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

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

  @override
  void initState() {
    super.initState();
    post = widget.post.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final timePublished = post['time_published'] as Timestamp;
    final dateTime = timePublished.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy  HH:mm').format(dateTime);
    

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Material(
        elevation: 60 ,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(3, 21, 37, 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: CircleAvatar(
                      backgroundImage: post['profile_photo'],
                      radius: 15,
                    ),
                  ),
                  Text(
                    post['username'],
                      style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(229, 210, 131, 1),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              if (post['title_and_year'] != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed:() {},
                    child: Text(
                      post['title_and_year'],
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(98, 119, 138, 1)),
                    ),
                  ),
                ),
              ),
              if (post['title_and_year'] != null)
              const SizedBox(height: 5),
              if (post['rating'] != null)
              RatingBar.builder(
                initialRating: post['rating'].toDouble(),
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
              if (post['rating'] != null)
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    post['content'],
                    style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
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
                              color: Color.fromRGBO(240, 240, 240, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w200
                            ),
                          ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(
                              Iconsax.heart5,
                              color: Colors.redAccent,
                              size: 23,
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, right: 12),
                            child: Text(
                              post['likes'].length.toString(),
                              style: GoogleFonts.dmSans(
                                color: Colors.redAccent,
                                fontSize: 12,
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
              
            ],
          ),
        ),
      ),
    );
  }
}