import 'package:lumus/models/movie.dart';
import 'package:lumus/models/series.dart';

class Review{
  int? id;
  int? userId;
  String? name;
  String? username;
  String? profilePhoto;
  String? content;
  int? rating;
  DateTime? time;
  int? movieId;
  Movie? movie;
  int? seriesId;
  Series? series;
  int? likes;
  List<String> comments;

  Review({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    required this.profilePhoto,
    required this.content,
    required this.rating,
    required this.time,
    required this.movieId,
    required this.movie,
    required this.seriesId,
    required this.series,
    required this.likes,
    required this.comments
  });
}
