import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/favorites.dart';
import 'package:lumus/components/follow_button.dart';
import 'package:lumus/components/follow_numbers.dart';
import 'package:lumus/components/post_ui.dart';
import 'package:lumus/pages/edit_page.dart';
import 'package:lumus/pages/lists/custom_lists.dart';
import 'package:lumus/pages/lists/favorites.dart';
import 'package:lumus/pages/lists/liked.dart';
import 'package:lumus/pages/lists/watched.dart';
import 'package:lumus/pages/lists/watchlist.dart';
import 'package:lumus/resources/firestore_methods.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MyProfile extends StatefulWidget {
  final String userUid;
  const MyProfile({super.key, required this.userUid});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int followers = 0;
  int following = 0;
  final double profileHeight = 100;
  var userData = {};
  bool isFollowing = false;
  int _selectedTabIndex = 0;
  late Stream<QuerySnapshot> _postsStream;
  late Stream<QuerySnapshot> _reviewsStream;
  int _numberOfPosts = 0;
  int _numberOfReviews = 0;
  bool hasFavorites = false;
  bool isLoading = false;
  bool get isOwnProfile => FirebaseAuth.instance.currentUser?.uid == widget.userUid;
  int likedCount = 0;
  int favoritesCount = 0;
  int watchedCount = 0;
  int watchlistCount = 0;
   

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
    setupPostsStream();
    _initializePostAndReviewCounts();
  }

  void setupPostsStream() {
    _postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .where('user_id', isEqualTo: widget.userUid)
        .where('is_review', isEqualTo: false)
        .snapshots();
    _reviewsStream = FirebaseFirestore.instance
        .collection('Posts')
        .where('user_id', isEqualTo: widget.userUid)
        .where('is_review', isEqualTo: true)
        .snapshots();
  }

  void _initializePostAndReviewCounts() async {
    try {
      var postsSnapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .where('user_id', isEqualTo: widget.userUid)
          .where('is_review', isEqualTo: false)
          .get();
      _numberOfPosts = postsSnapshot.docs.length;

      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .where('user_id', isEqualTo: widget.userUid)
          .where('is_review', isEqualTo: true)
          .get();
      _numberOfReviews = reviewsSnapshot.docs.length;

      var favoritesSnapshot = await FirebaseFirestore.instance
          .collection('Users collections')
          .doc(widget.userUid)
          .collection('Favorites')
          .get();

      hasFavorites = favoritesSnapshot.docs.isNotEmpty;

      setState(() {});
    } catch (e) {
      errorAlert();
    }
  }

  getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.userUid)
      .get();

      var userSnapLiked = await FirebaseFirestore.instance
      .collection('Users collections')
      .doc(widget.userUid)
      .collection('Liked')
      .get();

      var userSnapFavorites = await FirebaseFirestore.instance
      .collection('Users collections')
      .doc(widget.userUid)
      .collection('Favorites')
      .get();

      var userSnapWacthed = await FirebaseFirestore.instance
      .collection('Users collections')
      .doc(widget.userUid)
      .collection('Watched')
      .get();

      var userSnapWatchlist = await FirebaseFirestore.instance
      .collection('Users collections')
      .doc(widget.userUid)
      .collection('Watchlist')
      .get();

      likedCount = userSnapLiked.size;
      favoritesCount = userSnapFavorites.size;
      watchedCount = userSnapWacthed.size;
      watchlistCount = userSnapWatchlist.size;

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data()!;
      
      setState(() {
        
      });
    } catch (e) {  
      errorAlert();
    }
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null || FirebaseAuth.instance.currentUser!.isAnonymous) {
      // User is anonymous, show a message to login
      return Scaffold(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Você está logado como anônimo. Nada aqui para mostrar.',
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 15,
              ),
            ),
          ),
        ),
      );
    }
    return isLoading 
    ? const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
      )
    : Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        title: !isOwnProfile ? Text(
          userData['username'],
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        )
        : null
        ,
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        leading: !isOwnProfile ? IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        )
        : null
        ,
        actions: [
          if (isOwnProfile)
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
            icon: Icon(Icons.edit, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: profileHeight / 2,
                backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                child: ClipOval(
                  child: Image.network(
                    userData['profile_photo'] ??
                        "https://static.thenounproject.com/png/354384-200.png",
                    fit: BoxFit.cover,
                    width: profileHeight,
                    height: profileHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userData['username'],
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(!isOwnProfile)
            isFollowing ? FollowButton(
              text: "Seguindo",
              backgroundColor: const Color.fromRGBO(3, 21, 37, 1),
              textColor: Color.fromRGBO(240, 240, 240, 1),
              borderColor: Color.fromRGBO(240, 240, 240, 1),
              function: () async {
                await FirestoreMethods().followUser(
                  FirebaseAuth.instance.currentUser!.uid, 
                  widget.userUid
                );
                setState(() {
                  isFollowing = false;
                  followers--;
                });
              },
            ) 
            :
            FollowButton(
              text: "Seguir",
              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
              textColor: const Color.fromRGBO(3, 21, 37, 1),
              borderColor: Color.fromRGBO(240, 240, 240, 1),
              function: () async {
                await FirestoreMethods().followUser(
                  FirebaseAuth.instance.currentUser!.uid, 
                  widget.userUid
                );
                setState(() {
                  isFollowing = true;
                  followers++;
                });
              },
            ),
            NumberWidget(
              followers: followers,
              following: following,
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: userData['description'] != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  userData['description'] ?? 'No description available',
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            if(hasFavorites)
            const SizedBox(height: 16),
            Visibility(
              visible: hasFavorites,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'FAVORITOS',
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (hasFavorites)
                  Favorites(userUid: widget.userUid)
                ],
              ),
            ),
            if(hasFavorites)
            const SizedBox(height: 16),
            if(hasFavorites)
            const Divider(
              color: Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            DefaultTabController(
              length: 3,
              child: TabBar(
                onTap: (selectedTabIndex) {
                  setState(() {
                    _selectedTabIndex = selectedTabIndex;
                  });
                },
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.symmetric(horizontal: 16),
                indicatorColor: Color.fromRGBO(229, 210, 131, 1),
                tabs: [
                  Tab(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Publicações  ',
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                          TextSpan(
                            text: _numberOfPosts.toString(),
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Avaliações  ',
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                          TextSpan(
                            text: _numberOfReviews.toString(),
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(240, 240, 240, 1)
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Coleções",
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Color.fromRGBO(240, 240, 240, 1)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IndexedStack(
              index: _selectedTabIndex,
              children: [
                StreamBuilder(
                  stream: _postsStream,
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Check if there are no posts
                    if (snapshot.data?.docs.isEmpty ?? true) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Nenhuma publicação encontrada.',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(240, 240, 240, 1)
                            ),
                          ),
                        ),
                      );
                    }
                    // Display the posts
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        height: 600,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return PostUI(post: post);
                          },
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: _reviewsStream,
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Check if there are no posts
                    if (snapshot.data?.docs.isEmpty ?? true) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Nenhuma avaliação encontrada.',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(240, 240, 240, 1)
                            ),
                          ),
                        ),
                      );
                    }
                    // Display the posts
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        height: 600,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return PostUI(post: post);
                          },
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(229, 210, 131, 1)),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WatchedPage(userId: widget.userUid)), 
                                  );
                                },
                                child: Text(
                                  'Assistidos',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 21, 37, 1)
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              watchedCount.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        height: 1,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(229, 210, 131, 1)),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LikedPage(userId: widget.userUid)), 
                                  );
                                },
                                child: Text(
                                  'Curtidos',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 21, 37, 1)
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              likedCount.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        height: 1,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(229, 210, 131, 1)),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WatchlistPage(userId: widget.userUid)), 
                                  );
                                },
                                child: Text(
                                  'Quero assistir',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 21, 37, 1)
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              watchlistCount.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        height: 1,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(229, 210, 131, 1)),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FavoritesPage(userId: widget.userUid)), 
                                  );
                                },
                                child: Text(
                                  'Favoritos',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(3, 21, 37, 1)
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              favoritesCount.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber
                              ),
                            )
                          ],
                        ),
                      ), 
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        height: 1,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomListsPage(userData: userData)), 
                          );
                        }, 
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(229, 210, 131, 1)),
                        ),
                        child: Text(
                          "Suas listas",
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(3, 21, 37, 1)
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}