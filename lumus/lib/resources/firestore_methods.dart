import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumus/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> sendPost(
    String content,
    String userId,
    String username,
    String? profilePhoto
  ) async {
    String response = "some error occurred";

    try{
      String postId = const Uuid().v1();
      Post post = Post(
        userId: userId, 
        postId: postId,
        username: username, 
        profilePhoto: profilePhoto, 
        content: content, 
        rating: null, 
        timePublished: DateTime.now(), 
        movieId: null, 
        seriesId: null, 
        likes: [], 
        isReview: false,
        titleAndYear: null
      );

      _firestore.collection('Posts').doc(postId).set(post.toJson());
      response = "success";
    } catch (e){
      response = e.toString();
    }
    return response;
  }

  Future<String> sendPostAboutSeries(
    String content,
    String userId,
    String username,
    String? profilePhoto,
    int? seriesId,
    String? seriesNameAndYear
  ) async {
    String response = "some error occurred";

    try{
      String postId = const Uuid().v1();
      Post post = Post(
        userId: userId, 
        postId: postId,
        username: username, 
        profilePhoto: profilePhoto, 
        content: content, 
        rating: null, 
        timePublished: DateTime.now(), 
        movieId: null, 
        seriesId: seriesId, 
        likes: [], 
        isReview: false,
        titleAndYear: seriesNameAndYear
      );

      _firestore.collection('Posts').doc(postId).set(post.toJson());
      response = "success";
    } catch (e){
      response = e.toString();
    }
    return response;
  }

  Future<String> sendPostAboutMovie(
    String content,
    String userId,
    String username,
    String? profilePhoto,
    int? movieId,
    String? movieTitleAndYear
  ) async {
    String response = "some error occurred";

    try{
      String postId = const Uuid().v1();
      Post post = Post(
        userId: userId,
        postId: postId, 
        username: username, 
        profilePhoto: profilePhoto, 
        content: content, 
        rating: null, 
        timePublished: DateTime.now(), 
        movieId: movieId, 
        seriesId: null, 
        likes: [], 
        isReview: false,
        titleAndYear: movieTitleAndYear
      );

      _firestore.collection('Posts').doc(postId).set(post.toJson());
      response = "success";
    } catch (e){
      response = e.toString();
    }
    return response;
  }

  Future<String> sendReviewAboutMovie(
    String content,
    String userId,
    String username,
    String? profilePhoto,
    int? movieId,
    double rating,
    String? movieTitleAndYear
  ) async {
    String response = "some error occurred";

    try{
      String postId = const Uuid().v1();
      Post post = Post(
        userId: userId, 
        postId: postId,
        username: username, 
        profilePhoto: profilePhoto, 
        content: content, 
        rating: rating, 
        timePublished: DateTime.now(), 
        movieId: movieId, 
        seriesId: null, 
        likes: [], 
        isReview: true,
        titleAndYear: movieTitleAndYear
      );

      _firestore.collection('Posts').doc(postId).set(post.toJson());
      response = "success";
    } catch (e){
      response = e.toString();
    }
    return response;
  }

  Future<String> sendReviewAboutSeries(
    String content,
    String userId,
    String username,
    String? profilePhoto,
    int? seriesId,
    double rating,
    String? seriesNameAndYear
  ) async {
    String response = "some error occurred";

    try{
      String postId = const Uuid().v1();
      Post post = Post(
        userId: userId, 
        postId: postId,
        username: username, 
        profilePhoto: profilePhoto, 
        content: content, 
        rating: rating, 
        timePublished: DateTime.now(), 
        movieId: null, 
        seriesId: seriesId, 
        likes: [], 
        isReview: true,
        titleAndYear: seriesNameAndYear
      );

      _firestore.collection('Posts').doc(postId).set(post.toJson());
      response = "success";
    } catch (e){
      response = e.toString();
    }
    return response;
  }

  Future<void> likePost (String postId, String uid, List likes) async {
    try{
      if(likes.contains(uid)){
        await _firestore.collection('Posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid]),
        });
      } else{
        await _firestore.collection('Posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addToLiked (String userId, int movieOrSeriesId, String? posterPath) async {
    try{
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users collections').doc(userId);
      DocumentReference likedDocRef = userDocRef.collection('Liked').doc(movieOrSeriesId.toString());
      DocumentSnapshot movieSnapshot = await likedDocRef.get();
      if (movieSnapshot.exists) {
        await likedDocRef.delete();
        print('Removed from liked successfully');
      } else {
        await likedDocRef.set({
          'poster_path': posterPath,
        });
        print('Added to liked successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isInLikedStream(String userId, int movieOrSeriesId) {
    return _firestore
        .collection('Users collections')
        .doc(userId)
        .collection('Liked')
        .doc(movieOrSeriesId.toString())
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> addToWatched (String userId, int movieOrSeriesId, String? posterPath) async {
    try{
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users collections').doc(userId);
      DocumentReference watchedDocRef = userDocRef.collection('Watched').doc(movieOrSeriesId.toString());
      DocumentSnapshot movieSnapshot = await watchedDocRef.get();
      if (movieSnapshot.exists) {
        await watchedDocRef.delete();
        print('Removed from watched successfully');
      } else {
        await watchedDocRef.set({
          'poster_path': posterPath,
        });
        print('Added to watched successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isInWatchedStream(String userId, int movieOrSeriesId) {
    return _firestore
        .collection('Users collections')
        .doc(userId)
        .collection('Watched')
        .doc(movieOrSeriesId.toString())
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> addToWatchlist (String userId, int movieOrSeriesId, String? posterPath) async {
    try{
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users collections').doc(userId);
      DocumentReference watchlistDocRef = userDocRef.collection('Watchlist').doc(movieOrSeriesId.toString());
      DocumentSnapshot movieSnapshot = await watchlistDocRef.get();
      if (movieSnapshot.exists) {
        await watchlistDocRef.delete();
        print('Removed from Watchlist successfully');
      } else {
        await watchlistDocRef.set({
          'poster_path': posterPath,
        });
        print('Added to Watchlist successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isInWatchlistStream(String userId, int movieOrSeriesId) {
    return _firestore
        .collection('Users collections')
        .doc(userId)
        .collection('Watchlist')
        .doc(movieOrSeriesId.toString())
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
  
  Future<void> addToFavorites(String userId, int movieOrSeriesId, String? posterPath) async {
    try{
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users collections').doc(userId);
      DocumentReference favoriteDocRef = userDocRef.collection('Favorites').doc(movieOrSeriesId.toString());
      DocumentSnapshot movieSnapshot = await favoriteDocRef.get();
      if (movieSnapshot.exists) {
        await favoriteDocRef.delete();
        print('Removed from favorites successfully');
      } else {
        await favoriteDocRef.set({
          'poster_path': posterPath,
        });
        print('Added to favorites successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isInFavoritesStream(String userId, int movieOrSeriesId) {
    return _firestore
        .collection('Users collections')
        .doc(userId)
        .collection('Favorites')
        .doc(movieOrSeriesId.toString())
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> createCustomList (String userId, String creator, String name, String? description, String profilePhoto) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users collections');
      DocumentReference userDocument = usersCollection.doc(userId);
      String customId = const Uuid().v1();
      CollectionReference customCollection = userDocument.collection('Custom');
      DocumentReference customDocument = customCollection.doc(customId);
      await customDocument.set({
        'name': name,
        'creator': creator,
        'profile_photo': profilePhoto,
        'description': description,
        'user_id': userId,
        'custom_list_id' : customId
      });

      print('Custom list created successfully');
    } catch (e) {
      print('Error creating custom list: $e');
    }
  }

  Future<void> addItemToCustomList (String movieOrSeriesId, String? posterPath, String userId, String customListId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users collections")
          .doc(userId)
          .collection("Custom")
          .doc(customListId)
          .collection("Items")
          .doc(movieOrSeriesId)
          .set({'poster_path': posterPath});
    } catch (error) {
      print('Error adding movie to custom list: $error');
    }
  }

  Future<void> deleteCustomList(String userId, String customListId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users collections")
          .doc(userId)
          .collection("Custom")
          .doc(customListId)
          .delete();
      await FirebaseFirestore.instance
          .collection("Users collections")
          .doc(userId)
          .collection("Custom")
          .doc(customListId)
          .collection("Items")
          .get()
          .then((querySnapshot) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      print('Custom list deleted successfully');
    } catch (e) {
      print('Error deleting custom list: $e');
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {

    }
  }
}