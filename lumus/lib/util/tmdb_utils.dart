import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/models/series.dart';

class TmdbUtils{
  static List<int> getIdsFromSearchResults(List<Movie> results){
    List<int> ids = [];
    for(var result in results){
      int id = result.id ?? 0;
      ids.add(id);
    }
    return ids;
  }

  static List<int> getIdsFromSeriesResults(List<Series> results){
    List<int> ids = [];
    for(var result in results){
      int id = result.id ?? 0;
      ids.add(id);
    }
    return ids;
  }

  static Future<Map<int, CastAndCrew>> getDirectors(List<int> ids) async{
    Map<int, CastAndCrew> directorsMap = {};
    for(var id in ids){
      try {
        final crew = await TmdbApi().getCrew(id);

        for (var person in crew) {
          if (person.job == 'Director') {
            directorsMap[id] = person;
            break;
          }
        }
      } catch (e) {
        print('Error getting movie details for ID $id: $e');
      }
    }
    return directorsMap;
  }

  String getReleaseYear(String? releaseDate) {
    if (releaseDate != null && releaseDate.isNotEmpty) {
      List<String> dateParts = releaseDate.split('-');
        if (dateParts.isNotEmpty) {
          return dateParts[0];
        }
    }
    return 'N/A';
  }

  String getReleaseYearFromMovie(Movie movie) {
    if (movie.releaseDate != null) {
      return getReleaseYear(movie.releaseDate);
    }
    return 'N/A';
  }
}


