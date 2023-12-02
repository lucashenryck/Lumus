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
}