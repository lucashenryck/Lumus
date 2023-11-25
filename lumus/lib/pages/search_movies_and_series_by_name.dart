import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/pages/movie_details_page.dart';
import 'package:lumus/util/tmdb_utils.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  List<Movie> searchResults = [];
  final searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 32, 67, 1),
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: onSearchTextChanged,
            autofocus: true,
            controller: searchController,
            style: TextStyle(color: Color.fromRGBO(219, 158, 158, 1)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              fillColor: Color.fromRGBO(33, 53, 85, 1),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(33, 53, 85, 1)
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(33, 53, 85, 1)
                )
              ),
              hintText: 'Buscar filme, série ou usuário',
              hintStyle: GoogleFonts.dmSans(color: Color.fromRGBO(240, 240, 240, 1))
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index];
                final releaseYear = TmdbUtils().getReleaseYearFromMovie(movie);
                return GestureDetector(
                  onTap: () async {
                    final movieDetails = await TmdbApi().getMovieDetails(movie.id ?? 0);
                    final castFromMovie = await TmdbApi().getCast(movie.id ?? 0);
                    final crewFromMovie = await TmdbApi().getCrew(movie.id ?? 0);
                    final backdropsFromMovie = await TmdbApi().getBackdrops(movie.id ?? 0);
                    try{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movie: movieDetails,
                            cast: castFromMovie,
                            crew: crewFromMovie, 
                            backdrops: backdropsFromMovie,
                          ),
                        ),
                      );
                    }catch (e){
                      print('Erro ao obter detalhes do filme: $e');
                    }
                  },
                  child: Card(
                    color: Color.fromRGBO(33, 53, 85, 1),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          movie.posterPath != null
                          ? Image.network(
                              '${Constants.imagePath}${movie.posterPath}',
                              width: 120,
                              height: 180, 
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 120,
                              height: 180,
                              color: Colors.grey,
                            ),
                          SizedBox(width: 40),
                          Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: movie.title,
                                          style: GoogleFonts.dmSans(
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ($releaseYear)',
                                          style: GoogleFonts.dmSans(
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            fontSize: 17, // Ajuste o tamanho da fonte para o ano de lançamento
                                            fontWeight: FontWeight.normal, // Não negrito
                                          ),
                                        ),
                                      ]
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'De ',
                                          style: GoogleFonts.dmSans(
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            fontSize: 16, // Ajuste o tamanho da fonte para o ano de lançamento
                                            fontWeight: FontWeight.normal, // Não negrito
                                          ),
                                        ),
                                        TextSpan(
                                          text: movie.director?.name,
                                          style: GoogleFonts.dmSans(
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ), 
                                      ]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Future<void> onSearchTextChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      final results = await TmdbApi().searchMovie(query);
      setState(() {
        searchResults = results;
      });
      List<int> movieIds = TmdbUtils.getIdsFromSearchResults(searchResults);
      Map<int, CastAndCrew> directorsMap = await TmdbUtils.getDirectors(movieIds);

      for (var movie in searchResults) {
      movie.director = directorsMap[movie.id];
    }

    } catch (e) {
      print('Error searching for movies: $e');
      // Handle error as needed
    }
  }
}