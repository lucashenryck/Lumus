import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/genre.dart';

class Movie {
  int? id;
  String? title;
  String? backDropPath;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? releaseDate;
  int? budget;
  int? revenue;
  int? runtime;
  String? tagline;
  String? status;
  String? originalLanguage;
  List<Genre>? genres;
  CastAndCrew? director;

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.budget,
    required this.revenue,
    required this.runtime,
    required this.tagline,
    required this.status,
    required this.originalLanguage,
    required this.genres,
    this.director
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<dynamic>? genresJson = json['genres'];
    List<Genre>? genres = genresJson?.map((genreJson) => Genre.fromJson(genreJson)).toList();
    return Movie(
      id: json["id"],
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      budget: json["budget"],
      revenue: json["revenue"],
      runtime: json["runtime"],
      tagline: json["tagline"],
      status: json["status"],
      originalLanguage: json["original_language "],
      genres: genres
    );
  }  
}
