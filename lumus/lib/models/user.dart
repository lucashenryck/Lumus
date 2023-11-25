import 'package:lumus/models/movie.dart';
import 'package:lumus/models/post.dart';
import 'package:lumus/models/review.dart';
import 'package:lumus/models/series.dart';

class UserLumus{
  String? id;
  String? email;
  String? password;
  String? name;
  String? username;
  String? profilePhoto;
  List<Movie>? favoriteMovies;
  List<Series>? favoriteSeries;
  List<Movie>? watchlistMovies;
  List<Series>? watchlistSeries;
  List<Series>? watchedSeries;
  List<Movie>? watchedMovies;
  List<UserLumus>? following;
  List<UserLumus>? followers;
  List<Movie>? customMoviesLists;
  List<Series>? customSeriesLists;
  List<Movie>? likedMovies;
  List<Series>? likedSeries;
  String? description;
  List<Post>? posts;
  List<Review>? reviews;

  UserLumus({
    this.id,
    this.email,
    this.password,
    this.name,
    this.username,
    this.profilePhoto,
    this.favoriteMovies,
    this.favoriteSeries,
    this.watchlistMovies,
    this.watchlistSeries,
    this.watchedSeries,
    this.watchedMovies,
    this.following,
    this.followers,
    this.customMoviesLists,
    this.customSeriesLists,
    this.likedMovies,
    this.likedSeries,
    this.description,
    this.posts,
    this.reviews
  });

  UserLumus.emptyConstructor();

  Map<String, dynamic> toMap(){
    Map<String,dynamic> map = {
      "user_id" : id,
      "email"   : email,
      "name"    : name,
      "username"   : username,
      "password"   : password,
      "profile_photo" : profilePhoto,
      "description" : description
    };
    return map;
  }
}