import 'dart:convert';
import 'package:lumus/constants.dart';
import 'package:lumus/models/movie_image.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:lumus/models/series.dart';

class TmdbApi{
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const _trendingMoviesUrl = '/trending/movie/week?language=pt-br&api_key=${Constants.apiKey}';
  static const _trendingSeriesUrl = '/trending/tv/week?language=pt-br&api_key=${Constants.apiKey}';
  static const _movieDetailsUrl = '/movie/';
  static const _searchMovieUrl = '/search/movie';

  Future<List<Movie>> getTrendingMoviesToCarousel() async{
    final response = await http.get(Uri.parse('$_baseUrl$_trendingMoviesUrl'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Falha ao buscar filmes da semana!');
    }
  }

  Future<List<Series>> getTrendingSeriesToCarousel() async{
    final response = await http.get(Uri.parse('$_baseUrl$_trendingSeriesUrl'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((series) => Series.fromJson(series)).toList();
    }else{
      throw Exception('Falha ao buscar séries da semana');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl$_movieDetailsUrl$movieId?api_key=${Constants.apiKey}&language=pt-br'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return Movie.fromJson(decodedData);
    } else {
      throw Exception('Falha ao buscar detalhes do filme!');
    }
  }

  Future<List<CastAndCrew>> getCast(int movieId) async{
    final response = await http.get(Uri.parse('$_baseUrl$_movieDetailsUrl$movieId/credits?api_key=${Constants.apiKey}&language=pt-br'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['cast'] as List;
      return decodedData.map((cast) => CastAndCrew.fromJson(cast)).toList();
    }else{
      throw Exception('Falha ao buscar elenco do filme!');
    }
  }

  Future<List<CastAndCrew>> getCrew(int movieId) async{
    final response = await http.get(Uri.parse('$_baseUrl$_movieDetailsUrl$movieId/credits?api_key=${Constants.apiKey}'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['crew'] as List;
      return decodedData.map((crew) => CastAndCrew.fromJson(crew)).toList();
    }else{
      throw Exception('Falha ao buscar equipe técnica do filme!');
    }
  }

  Future<List<MovieImage>> getBackdrops(int movieId) async{
    final response = await http.get(Uri.parse('$_baseUrl$_movieDetailsUrl$movieId/images?api_key=${Constants.apiKey}'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['backdrops'] as List;
      return decodedData.map((image) => MovieImage.fromJson(image)).toList();
    }else{
      throw Exception('Falha ao buscar imagens de fundo do filme!');
    }
  }

  Future<List<Movie>> searchMovie(String query) async{
    final response = await http.get(Uri.parse('$_baseUrl$_searchMovieUrl?query=$query&include_adult=false&language=pt-br&api_key=${Constants.apiKey}'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Não conseguiu procurar filmes!');
    }
  }
}