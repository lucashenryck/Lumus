import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/models/series.dart';
import 'package:lumus/pages/create/create_post_about_movie.dart';
import 'package:lumus/pages/create/create_post_about_series.dart';

class SearchingForPostPage extends StatefulWidget {
  const SearchingForPostPage({super.key});

  @override
  State<SearchingForPostPage> createState() => _SearchingForPostPageState();
}

class _SearchingForPostPageState extends State<SearchingForPostPage> 
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> movieResults = [];
  List<Series> seriesResults = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        movieResults.clear();
        seriesResults.clear();
        searchController.clear();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 53, 85, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: onSearchTextChanged,
            autofocus: true,
            controller: searchController,
            style: TextStyle(color: Color.fromRGBO(240, 240, 240, 1)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              fillColor: Color.fromRGBO(5, 34, 59, 1),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(5, 34, 59, 1)
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(5, 34, 59, 1)
                )
              ),
              hintText: 'Pesquisar',
              hintStyle: GoogleFonts.dmSans(color: Color.fromRGBO(240, 240, 240, 1))
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Filmes',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 17,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Séries',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tabController.index == 1 ? seriesResults.length : movieResults.length,
              itemBuilder: (context, index) {
                if (_tabController.index == 1) {
                  final series = seriesResults[index];
                  return buildSeriesCard(series);
                } else {
                  final movie = movieResults[index];
                  return buildMovieCard(movie);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMovieCard(Movie movie) {
    DateTime? releaseDate = movie.releaseDate != ""
    ? DateTime.parse(movie.releaseDate!)
    : null;

    String releaseYear = releaseDate != null
        ? '(${DateFormat('yyyy').format(releaseDate)})'
        : '(N/A)';

    String movieInfo = "${movie.title ?? "Não informado"}  $releaseYear";

    return GestureDetector(
      onTap: () async {
      try{
        final movieDetails = await TmdbApi().getMovieDetails(movie.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostAboutMovie(
              movie: movieDetails,
            ),
          ),
        );
      }catch (e){
        print('Erro ao obter detalhes do filme: $e');
      }
    },
      child: Card(
        color: Color.fromRGBO(3, 30, 54, 1),
        elevation: 25,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              movie.posterPath != null
                  ? Image.network(
                      '${Constants.imagePath}${movie.posterPath}',
                      width: 90,
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 90,
                      height: 125,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Text(
                              movieInfo,
                              style: GoogleFonts.dmSans(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSeriesCard(Series series) {
    DateTime? releaseDate = series.firstAirDate != ""
        ? DateTime.parse(series.firstAirDate!)
        : null;

    // Format the release date to get only the year
    String releaseYear = releaseDate != null
        ? '(${DateFormat('yyyy').format(releaseDate)})'
        : '(N/A)';

    String seriesInfo = "${series.name ?? "Não informado"}  $releaseYear";

    return GestureDetector(
      onTap: () async {
        try{
          final seriesDetails = await TmdbApi().getSeriesDetails(series.id!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostAboutSeries(
                series: seriesDetails,
              ),
            ),
          );
        }catch (e){
          print('Erro ao obter detalhes do filme: $e');
        }
      },
      child: Card(
        color: Color.fromRGBO(3, 30, 54, 1),
        elevation: 25,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              series.posterPath != null
                  ? Image.network(
                      '${Constants.imagePath}${series.posterPath}',
                      width: 90,
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 90,
                      height: 125,
                      color: Colors.grey,
                    ),
              SizedBox(width: 20),
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        seriesInfo,
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSearchTextChanged(String query) async {
  if (query.isEmpty) {
    setState(() {
      movieResults.clear();
      seriesResults.clear();
    });
    return;
  }

  try {
    if (_tabController.index == 0) {
      final movieResults = await TmdbApi().searchMovie(query);
      setState(() {
        this.movieResults = movieResults;
        seriesResults.clear();
      });
    } else if (_tabController.index == 1) {
      final seriesResults = await TmdbApi().searchSeries(query);
      setState(() {
        this.seriesResults = seriesResults;
        movieResults.clear();
      });
    } else {
      // Handle user search (if needed)
    }
  } catch (e) {
    print('Error searching: $e');
  }
}
}