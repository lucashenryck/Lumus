import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/pages/searching_page.dart';
import 'package:lumus/search_content/list_movies.dart';
import 'package:lumus/search_content/trending_movies.dart';
import 'package:lumus/components/drawer.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/models/series.dart';
import 'package:lumus/search_content/trending_series.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

late Future<List<Movie>> trendingMovies;
late Future<List<Series>> trendingSeries;

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState(){
  super.initState();
  trendingMovies = TmdbApi().getTrendingMoviesToCarousel();
  trendingSeries = TmdbApi().getTrendingSeriesToCarousel();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: SizedBox(
          height: 40,
          child: TextField(
            readOnly: true,
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
              hintStyle: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1), 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
              suffixIcon: Icon(
                Icons.search, 
                color: Color.fromRGBO(240, 240, 240, 1)
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchingPage()),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(17),
              child: Text(
                'Top 10 filmes da semana', 
                style: GoogleFonts.dmSans(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Color.fromRGBO(240, 240, 240, 1)
                ),
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: trendingMovies,
                builder: (context, snapshot){
                  if(snapshot.hasError){
                     return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }else if(snapshot.hasData){
                    return TrendingMovies(snapshot: snapshot);
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Text(
                'Top 10 séries da semana', 
                style: GoogleFonts.dmSans(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Color.fromRGBO(240, 240, 240, 1)
                ),
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: trendingSeries,
                builder: (context, snapshot){
                  if(snapshot.hasError){
                     return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }else if(snapshot.hasData){
                    return TrendingSeries(snapshot: snapshot);
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Text(
                'Novidades dos amigos',
                style: GoogleFonts.dmSans(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Color.fromRGBO(240, 240, 240, 1)
                ),
              ),
            ),
            const ListMoviesSlider(),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Text(
                'Recomendações dos amigos',
                style: GoogleFonts.dmSans(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Color.fromRGBO(240, 240, 240, 1)
                ),
              ),
            ),
            const ListMoviesSlider(),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}


