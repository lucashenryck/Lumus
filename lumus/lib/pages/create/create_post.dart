import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/util/tmdb_utils.dart';

class MyPost extends StatefulWidget {
  const MyPost({
    super.key, 
  });

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  List<Movie> searchResults = [];
  final searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
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
          hintText: 'Sobre o que você quer publicar?',
          hintStyle: GoogleFonts.dmSans(color: Color.fromRGBO(240, 240, 240, 1))
          ),
        ),
      ],
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