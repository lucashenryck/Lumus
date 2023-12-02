import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String? userId;
  final String? postId;
  final String? username;
  final String? profilePhoto;
  final String? content;
  final double? rating;
  final timePublished;
  final int? movieId;
  final int? seriesId;
  final likes;
  final bool isReview;
  final String? titleAndYear;

  Post({
    required this.userId,
    required this.postId,
    required this.username,
    required this.profilePhoto,
    required this.content,
    required this.rating,
    required this.timePublished,
    required this.movieId,
    required this.seriesId,
    required this.likes,
    required this.isReview,
    required this.titleAndYear
  });

  Map<String, dynamic> toJson() => {
      "user_id"   : userId,
      "username"   : username,
      "profile_photo" : profilePhoto,
      "content" : content, 
      "rating" : rating,
      "time_published" : timePublished,
      "movie_id" : movieId,
      "series_id" : seriesId,
      "likes" : likes,
      "is_review" : isReview,
      "title_and_year" : titleAndYear,
      "post_id" : postId
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      userId: snapshot['user_id'],
      username: snapshot['username'],
      profilePhoto: snapshot['profile_photo'],
      content: snapshot['content'],
      rating: snapshot['rating'],
      timePublished: snapshot['time_published'],
      movieId: snapshot['moive_id'],
      seriesId: snapshot['series_id'],
      likes: snapshot['likes'],
      isReview: snapshot['is_review'],
      titleAndYear: snapshot['title_and_year'],
      postId: snapshot['post_id']
    );
  }
}