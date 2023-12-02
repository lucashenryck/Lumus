import 'package:flutter/material.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/pages/movie_details_page.dart';

class TrendingMovies extends StatelessWidget {
  const TrendingMovies({
    super.key,
    required this.snapshot
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10, 
        itemBuilder: (context, itemIndex){
          final movie = snapshot.data[itemIndex];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                try{
                  final movieDetails = await TmdbApi().getMovieDetails(movie.id);
                  final cast = await TmdbApi().getCast(movie.id);
                  final crew = await TmdbApi().getCrew(movie.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                        movie: movieDetails,
                        cast: cast,
                        crew: crew,
                      ),
                    ),
                  );
                }catch (e){
                  print('Erro ao obter detalhes do filme: $e');
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 225,
                      width: 140,
                      child: Image.network(
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        '${Constants.imagePath}${snapshot.data[itemIndex].posterPath}'
                      )
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${itemIndex + 1}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  )
                ],
              ),
            ),
          );
        }, 
      ),
    );
  }
}