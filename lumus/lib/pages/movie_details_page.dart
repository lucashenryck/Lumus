import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/movie.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/pages/searching%20for%20create/searching_page_for_review.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:lumus/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    super.key, 
    required this.movie, 
    required this.cast, 
    required this.crew
  });

  final Movie movie;
  final List<CastAndCrew> cast;
  final List<CastAndCrew> crew;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Stream<bool> isLikedStream;
  late Stream<bool> isWatchedStream;
  late Stream<bool> isToWatchStream;

  @override
  void initState() {
    super.initState();
    isLikedStream = FirestoreMethods().isMovieInLikedStream(FirebaseAuth.instance.currentUser!.uid, widget.movie.id!);
    isWatchedStream = FirestoreMethods().isMovieInWatchedStream(FirebaseAuth.instance.currentUser!.uid, widget.movie.id!);
    isToWatchStream = FirestoreMethods().isMovieInWatchlistStream(FirebaseAuth.instance.currentUser!.uid, widget.movie.id!);
  }

  void addToLiked(
    String userId,
    int movieId,
    String? posterPath 
  ) async {
    try{
      await FirestoreMethods().addToLiked(
        userId, 
        movieId, 
        posterPath
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void addToWatched(
    String userId,
    int movieId,
    String? posterPath 
  ) async {
    try{
      await FirestoreMethods().addToWatched(
        userId, 
        movieId, 
        posterPath
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void addToWatchlist(
    String userId,
    int movieId,
    String? posterPath 
  ) async {
    try{
      await FirestoreMethods().addToWatchlist(
        userId, 
        movieId, 
        posterPath
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;

    CastAndCrew? findDirector(){
      return widget.crew.firstWhere(
        (member) => member.job == "Director"
      );
    }
    Size size = MediaQuery.of(context).size;
    CastAndCrew? director = findDirector();
    String directorName = director?.name ?? "Não informado";
    bool movieHasTagline = widget.movie.tagline != null && widget.movie.tagline!.isNotEmpty;

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
    String durationText = formatDuration(widget.movie.runtime ?? 0);

    DateTime? releaseDate = widget.movie.releaseDate != ""
        ? DateTime.parse(widget.movie.releaseDate!)
        : null;
    String releaseYear = releaseDate != null
        ? '(${DateFormat('yyyy').format(releaseDate)})'
        : '(Não informado)';
    String movieInfo = "${widget.movie.title ?? "Não informado"}  $releaseYear";

    void showMoreOptions() {
      showModalBottomSheet(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    movieInfo,
                    style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(229, 210, 131, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => addToLiked(user.id, widget.movie.id!, widget.movie.posterPath), 
                      icon: StreamBuilder<bool>(
                        stream: isLikedStream,
                        builder: (context, snapshot) {
                          bool isInLiked = snapshot.data ?? false;
                          return Icon(
                            isInLiked ? Ionicons.heart : Ionicons.heart_outline,
                            color: isInLiked ? Colors.red : Colors.white,
                          );
                        },
                      ),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: () => addToWatched(user.id, widget.movie.id!, widget.movie.posterPath), 
                      icon: StreamBuilder<bool>(
                        stream: isWatchedStream,
                        builder: (context, snapshot) {
                          bool isWatchedStream = snapshot.data ?? false;
                          return Icon(
                            isWatchedStream ? Ionicons.eye : Ionicons.eye_off,
                            color: isWatchedStream ? Colors.greenAccent : Color.fromRGBO(240, 240, 240, 1),
                          );
                        },
                      ),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: () => addToWatchlist(user.id, widget.movie.id!, widget.movie.posterPath), 
                      icon: StreamBuilder<bool>(
                        stream: isToWatchStream,
                        builder: (context, snapshot) {
                          bool isToWatchStream = snapshot.data ?? false;
                          return Icon(
                            isToWatchStream ? Ionicons.time : Ionicons.time_outline,
                            color: isToWatchStream ? Colors.blueAccent : Color.fromRGBO(240, 240, 240, 1),
                          );
                        },
                      ),
                      iconSize: 50,
                    ),
                  ],
                ),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  itemSize: 50,
                  minRating: 0,
                  unratedColor: Color.fromRGBO(0, 0, 0, 1),
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
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                              return SearchingForReviewPage();
                          }),
                        );
                      }, 
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)), // Change the color here
                      ),
                      child: Text(
                        'Quer fazer uma review?',
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Icons.playlist_add),
                      color: Color.fromRGBO(240, 240, 240, 1),
                      iconSize: 50
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromRGBO(3, 30, 54, 1),
            expandedHeight: size.height * 0.225,
            floating: false,
            pinned: true,
            elevation: 20,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    '${Constants.imagePath}${widget.movie.backDropPath}',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                  Container(
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
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        movieInfo,
                        style: GoogleFonts.dmSans(
                          color: Colors.amber,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: showMoreOptions, 
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Color.fromRGBO(240, 240, 240, 1),
                      size: 40,
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.movie.originalTitle ?? "N/A",
                  style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300
                    ),
                ),
              ),
              const SizedBox(height: 8),
              if (director != null || directorName != "")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    directorName,
                    style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  indent: 15,
                  endIndent: 15,
                ),
                const SizedBox(height: 10),
                if (widget.movie.genres != null && widget.movie.genres!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    runAlignment: WrapAlignment.start, // Align children at the start of each line
                    children: widget.movie.genres!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final genre = entry.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            genre.name ?? 'Não informado',
                            style: GoogleFonts.dmSans(
                              color: Color.fromRGBO(229, 210, 131, 1),
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (index < widget.movie.genres!.length - 1)
                            Icon(
                              Icons.fiber_manual_record,
                              size: 8,
                              color: Color.fromRGBO(240, 240, 240, 1),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  indent: 15,
                  endIndent: 15,
                ),
                const SizedBox(height: 16),
                if (widget.movie.tagline != "")
                Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.movie.tagline ?? "Não informado",
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                if (widget.movie.overview != "")
                Center(
                  child: Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.movie.overview ?? "Não informado",
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 0.825,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if(widget.cast.isNotEmpty)
                Column(
                  children: [
                    Divider(
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Elenco',
                        style: GoogleFonts.dmSans(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.cast.length,
                        itemBuilder: (context, index) {
                          return CastCard(actor: widget.cast[index]);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if(widget.crew.isNotEmpty)
                Column(
                  children: [
                    Divider(
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Equipe técnica',
                        style: GoogleFonts.dmSans(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.crew.length,
                        itemBuilder: (context, index) {
                          return CastCard(
                              actor: widget.crew[index]);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                      "REVIEWS",
                      style: GoogleFonts.dmSans(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 100),
            ]),
          ),
        ]
      ),
    );
  }
}

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
              image: actor.profilePath != null ? 
              DecorationImage(
                image: NetworkImage('${Constants.imagePath}${actor.profilePath}'), 
                fit: BoxFit.cover
              ) 
              : 
              DecorationImage(
                image: NetworkImage('https://static.thenounproject.com/png/354384-200.png'), // Replace with your fallback image URL
                fit: BoxFit.cover,
              ),
              color: actor.profilePath != null ? null : const  Color.fromRGBO(240, 240, 240, 1),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  actor.name ?? 'N/A',
                  style: TextStyle(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  actor.job ?? (actor.character ?? 'N/A'),
                  style: TextStyle(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}