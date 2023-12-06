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
      DocumentReference favoriteDocRef = userDocRef.collection('Liked').doc(movieOrSeriesId.toString());
      DocumentSnapshot movieSnapshot = await favoriteDocRef.get();
      if (movieSnapshot.exists) {
        await favoriteDocRef.delete();
        print('Movie removed from liked successfully');
      } else {
        await favoriteDocRef.set({
          'poster_path': posterPath,
        });
        print('Movie added to liked successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isMovieInLikedStream(String userId, int movieOrSeriesId) {
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
        print('Movie removed from watched successfully');
      } else {
        await watchedDocRef.set({
          'poster_path': posterPath,
        });
        print('Movie added to watched successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isMovieInWatchedStream(String userId, int movieOrSeriesId) {
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
        print('Movie removed from Watchlist successfully');
      } else {
        await watchlistDocRef.set({
          'poster_path': posterPath,
        });
        print('Movie added to Watchlist successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> isMovieInWatchlistStream(String userId, int movieOrSeriesId) {
    return _firestore
        .collection('Users collections')
        .doc(userId)
        .collection('Watchlist')
        .doc(movieOrSeriesId.toString())
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
}