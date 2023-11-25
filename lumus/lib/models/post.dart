import 'package:lumus/models/movie.dart';
import 'package:lumus/models/series.dart';

class Post{
  int? id;
  int? userId;
  int? reviewId;
  String? name;
  String? username;
  String? profilePhoto;
  String? content;
  DateTime? time;
  int? movieId;
  Movie? movie;
  int? seriesId;
  Series? series;
  int? likes;
  List<String>? comments;

  Post({
    required this.id,
    required this.userId,
    required this.reviewId,
    required this.name,
    required this.username,
    required this.profilePhoto,
    required this.content,
    required this.time,
    required this.movieId,
    required this.movie,
    required this.seriesId,
    required this.series,
    required this.likes,
    required this.comments
  });
}