import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/models/movie_image.dart';
import 'package:lumus/util/tmdb_utils.dart';

class CastCard extends StatelessWidget {
  final CastAndCrew actor;
  const CastCard({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: actor.profilePath != null ? DecorationImage(image: NetworkImage('${Constants.imagePath}${actor.profilePath}'), fit: BoxFit.cover) : null,
              color: actor.profilePath != null ? null : const  Color.fromRGBO(240, 240, 240, 1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name ?? 'N/A',
            style: TextStyle(
              color: Color.fromRGBO(240, 240, 240, 1),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            actor.character ?? 'N/A',
            style: TextStyle(
              color: Color.fromRGBO(240, 240, 240, 1),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movie, required this.cast, required this.crew, required this.backdrops});

  final Movie movie;
  final List<CastAndCrew> cast;
  final List<CastAndCrew> crew;
  final List<MovieImage> backdrops;

  CastAndCrew? findDirector(){
    return crew.firstWhere(
      (member) => member.job == "Director"
    );
  }

  List<CastAndCrew> getCastWithDirector() {
    List<CastAndCrew> castWithDirector = List.from(crew);
    CastAndCrew? director = findDirector();
    if (director != null) {
      castWithDirector.insert(0, director);
    }
    return castWithDirector;
  }

  String getGenresString() {
    if (movie.genres != null && movie.genres!.isNotEmpty) {
      List<String> genreNames = movie.genres!.map((genre) => genre.name ?? 'N/A').toList();
      return genreNames.join(', ');
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    CastAndCrew? director = findDirector();
    bool movieHasTagline = movie.tagline != null && movie.tagline!.isNotEmpty;

    List<MovieImage> shuffledBackdrops = List.from(backdrops);
    shuffledBackdrops.shuffle();
    shuffledBackdrops = shuffledBackdrops.where((image) => 
    image.iso == null).toList();

    String releaserYear = TmdbUtils().getReleaseYear(movie.releaseDate);
    String movieTitle = movie.title ?? 'N/A';

    String formatDuration(int minutes) {
      if (minutes <= 0) {
        return 'N/A';
      }

      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      if (hours > 0 && remainingMinutes > 0) {
        return '${hours}h ${remainingMinutes}min';
      } else if (hours > 0) {
        return '$hours';
      } else {
        return '$remainingMinutes';
      }
    }
    String durationText = formatDuration(movie.runtime ?? 0);

    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      '${Constants.imagePath}${shuffledBackdrops.first.filepath}',
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SizedBox(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '$movieTitle ',
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ($releaserYear)',
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  movie.originalTitle ?? "",
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'De ',
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: director?.name,
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button click logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
                      side: BorderSide(color: Color.fromRGBO(229, 210, 131, 1), width: 2), // Set yellow border
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color.fromRGBO(229, 210, 131, 1),
                        ),
                        SizedBox(width: 8), // Adjust the spacing between icon and text
                        Text(
                          'Avaliar',
                          style: TextStyle(color: Color.fromRGBO(229, 210, 131, 1)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  height: 20,
                  color: Color.fromRGBO(240, 240, 240, 1),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      durationText,
                      style: GoogleFonts.dmSans(color: Color.fromRGBO(240, 240, 240, 1), fontSize: 16),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      getGenresString(),
                      style: GoogleFonts.dmSans(color: Color.fromRGBO(240, 240, 240, 1), fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                if (movieHasTagline)
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      movie.tagline ?? "",
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                SizedBox(height: movieHasTagline ? 25 : 0),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    movie.overview ?? "",
                    style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  height: 20,
                  color: Color.fromRGBO(240, 240, 240, 1),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                Text(
                  'Elenco',
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    itemBuilder: (context, index) {
                      return CastCard(actor: cast[index]);
                    },
                  ),
                ),
                Divider(
                  height: 20,
                  color: Color.fromRGBO(240, 240, 240, 1),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                Text(
                  'Equipe técnica',
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: getCastWithDirector().length,
                    itemBuilder: (context, index) {
                      return CastCard(actor: getCastWithDirector()[index]);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}