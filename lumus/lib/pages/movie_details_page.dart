import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
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
            actor.job ?? (actor.character ?? 'N/A'),
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
  const MovieDetailsPage({super.key, required this.movie, required this.cast, required this.crew});

  final Movie movie;
  final List<CastAndCrew> cast;
  final List<CastAndCrew> crew;

  CastAndCrew? findDirector(){
    return crew.firstWhere(
      (member) => member.job == "Director"
    );
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
    Size size = MediaQuery.of(context).size;
    CastAndCrew? director = findDirector();
    bool movieHasTagline = movie.tagline != null && movie.tagline!.isNotEmpty;

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
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromRGBO(3, 30, 54, 1),
              expandedHeight: size.height * 0.225,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '$movieTitle ',
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 20,
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
                  textAlign: TextAlign.start,
                ),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        '${Constants.imagePath}${movie.backDropPath}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned.fill(
                      bottom: -5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(3, 21, 37, 1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10),
                  Column(
                    children: [
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
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        height: 20,
                        color: Color.fromRGBO(240, 240, 240, 1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            durationText,
                            style: GoogleFonts.dmSans(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            getGenresString(),
                            style: GoogleFonts.dmSans(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                fontSize: 16),
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
                          itemCount: crew.length,
                          itemBuilder: (context, index) {
                            return CastCard(
                                actor: crew[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}