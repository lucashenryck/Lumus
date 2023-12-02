import 'dart:convert';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/episode.dart';
import 'package:lumus/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:lumus/models/series.dart';

class TmdbApi{
  static const _baseUrl = 'https://api.themoviedb.org/3';
  //Movies
  static const _trendingMoviesUrl = '/trending/movie/week?language=pt-br&api_key=${Constants.apiKey}';
  static const _movieDetailsUrl = '/movie/';
  static const _searchMovieUrl = '/search/movie';
  //Series
  static const _trendingSeriesUrl = '/trending/tv/week?language=pt-br&api_key=${Constants.apiKey}';
  static const _seriesDetailsUrl = '/tv/';
  static const _searchSeriesUrl = '/search/tv';

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
    final response = await http.get(Uri.parse('$_baseUrl$_movieDetailsUrl$movieId/credits?api_key=${Constants.apiKey}&language=pt-br'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['crew'] as List;
      return decodedData.map((crew) => CastAndCrew.fromJson(crew)).toList();
    }else{
      throw Exception('Falha ao buscar equipe técnica do filme!');
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

  Future<Series> getSeriesDetails(int seriesId) async{
    final response = await http.get(Uri.parse('$_baseUrl$_seriesDetailsUrl$seriesId?api_key=${Constants.apiKey}&language=pt-br'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body);
      return Series.fromJson(decodedData);
    } else {
      throw Exception('Falha ao buscar detalhes da série!');
    }
  }

  Future<List<Series>> searchSeries(String query) async{
    final response = await http.get(Uri.parse('$_baseUrl$_searchSeriesUrl?query=$query&include_adult=false&language=pt-br&api_key=${Constants.apiKey}'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((series) => Series.fromJson(series)).toList();
    }else{
      throw Exception('Não conseguiu procurar filmes!');
    }
  }

  Future<List<CastAndCrew>> getCastFromSeries(int seriesId) async {
    final response = await http.get(Uri.parse('$_baseUrl$_seriesDetailsUrl$seriesId/credits?api_key=${Constants.apiKey}&language=pt-br'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['cast'] as List;
      return decodedData.map((cast) => CastAndCrew.fromJson(cast)).toList();
    } else {
      throw Exception("Falha ao buscar elenco da série");
    }
  }

  Future<List<CastAndCrew>> getCrewFromSeries(int seriesId) async {
    final response = await http.get(Uri.parse('$_baseUrl$_seriesDetailsUrl$seriesId/credits?api_key=${Constants.apiKey}&language=pt-br'));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['crew'] as List;
      return decodedData.map((cast) => CastAndCrew.fromJson(cast)).toList();
    } else {
      throw Exception("Falha ao buscar elenco da série");
    }
  }

  Future<List<Episode>> getEpisodesInSeason(int seriesId, int seasonNumber) async {
    final response = await http.get(Uri.parse('$_baseUrl$_seriesDetailsUrl$seriesId/season/$seasonNumber?api_key=${Constants.apiKey}&language=pt-br'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['episodes'] as List;
      return decodedData.map((episode) => Episode.fromJson(episode)).toList();
    } else {
      throw Exception('Falha ao buscar episódios da temporada!');
    }
  }
}