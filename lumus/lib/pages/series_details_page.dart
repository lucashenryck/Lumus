import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/castncrew.dart';
import 'package:lumus/models/episode.dart';
import 'package:lumus/models/series.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/pages/searching%20for%20create/searching_page_for_review.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:lumus/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class SeriesDetailsPage extends StatefulWidget {
  const SeriesDetailsPage({
    super.key, 
    required this.series,
    required this.cast,
    required this.crew
  });

  final Series series;
  final List<CastAndCrew> cast;
  final List<CastAndCrew> crew;

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  int? selectedSeason;
  late Future<List<Episode>> episodes;
    
  @override
  void initState() {
    super.initState();
    episodes = Future.value([]);
  }

  void addToFavorites(
    String userId,
    int seriesId,
    String? posterPath 
  ) async {
    try{
      await FirestoreMethods().addToLiked(
        userId, 
        seriesId, 
        posterPath
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;
    Size size = MediaQuery.of(context).size;

    DateTime? releaseDate = widget.series.firstAirDate != ""
        ? DateTime.parse(widget.series.firstAirDate!)
        : null;
    String releaseYear = releaseDate != null
        ? '(${DateFormat('yyyy').format(releaseDate)})'
        : '(N/A)';

    String seriesInfo = "${widget.series.name ?? "Não informado"}  $releaseYear";

    void _showMoreOptions() {
      showModalBottomSheet(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    seriesInfo,
                    style: GoogleFonts.dmSans(
                      color: Colors.amber,
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
                      onPressed: () => addToFavorites(
                        user.id, 
                        widget.series.id!, 
                        widget.series.posterPath
                      ), 
                      icon: Icon(Ionicons.heart_outline),
                      color: Color.fromRGBO(240, 240, 240, 1),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Ionicons.eye_off),
                      color: Color.fromRGBO(240, 240, 240, 1),
                      iconSize: 60
                    ),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Ionicons.time_outline),
                      color: Color.fromRGBO(240, 240, 240, 1),
                      iconSize: 50
                    ),
                  ],
                ),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
            backgroundColor: Color.fromRGBO(3, 21, 37, 1),
            expandedHeight: size.height * 0.225,
            floating: false,
            pinned: true,
            elevation: 20,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    '${Constants.imagePath}${widget.series.backDropPath}',
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
                        seriesInfo,
                        style: GoogleFonts.dmSans(
                          color: Colors.amber,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showMoreOptions, 
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Color.fromRGBO(240, 240, 240, 1),
                      size: 40,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.series.originalName ?? "Não informado",
                  style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300
                    ),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.series.createdBy != null && widget.series.createdBy!.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    widget.series.createdBy!
                        .map((creator) => creator.name ?? "N/A")
                        .join(', '),
                    style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  indent: 15,
                  endIndent: 15,
                ),
                const SizedBox(height: 10),
                if (widget.series.genres != null && widget.series.genres!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    runAlignment: WrapAlignment.start, // Align children at the start of each line
                    children: widget.series.genres!.asMap().entries.map((entry) {
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
                          if (index < widget.series.genres!.length - 1)
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
                if (widget.series.tagline != "")
                Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.series.tagline ?? "Não informado",
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
                if (widget.series.overview != "")
                Center(
                  child: Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.series.overview ?? "Não informado",
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
                Divider(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "EPISÓDIOS",
                        style: GoogleFonts.dmSans(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        iconSize: 40,
                        iconDisabledColor: Color.fromRGBO(240, 240, 240, 1),
                        iconEnabledColor: Color.fromRGBO(240, 240, 240, 1),
                        value: selectedSeason,
                        items: [
                          DropdownMenuItem<int?>(
                            value: -1, // Use a unique value for the "Remove Episodes" option
                            child: Text(
                              'Limpar resultados',
                              style: GoogleFonts.dmSans(
                                color: Colors.red, // You can adjust the color
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...widget.series.seasons
                              !.where((season) => season.seasonNumber! > 0) // Exclude season 0
                              .map((season) {
                                return DropdownMenuItem<int>(
                                  value: season.seasonNumber,
                                  child: Text(
                                    season.name ?? "",
                                    style: GoogleFonts.dmSans(
                                      color: Color.fromRGBO(3, 21, 37, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value == -1) {
                              // Remove Episodes option selected
                              selectedSeason = null;
                              episodes = Future.value([]);
                            } else {
                              selectedSeason = value;
                              episodes = TmdbApi().getEpisodesInSeason(widget.series.id!, selectedSeason!);
                            }
                          });
                        },
                        hint: Text(
                          'Selecione uma temporada',
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<Episode>>(
                      future: episodes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Color.fromRGBO(240, 240, 240, 1),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          if (selectedSeason == null) {
                            return SizedBox.shrink();
                          } else {
                            return Text('Nenhum episódio disponível para a temporada selecionada');
                          }
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Temporada ${selectedSeason ?? ""}', // Display the selected season
                                  style: GoogleFonts.dmSans(
                                    color: Color.fromRGBO(240, 240, 240, 1), // Adjust color as needed
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: snapshot.data!
                                    .map(
                                      (episode) => Column(
                                        children: [
                                          EpisodeCard(
                                            episode: episode,
                                          ),
                                          Divider(
                                            color: Color.fromRGBO(240, 240, 240, 1),
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
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
                          fontSize: 18,
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
                          fontSize: 18,
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
                      "Avaliações",
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
        ],
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
              const DecorationImage(
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


class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard({
    Key? key,
    required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEpisodeOverview(context, episode);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(3, 21, 37, 1), // Adjust the color as needed
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.name ?? 'Episode Name',
                      style: TextStyle(
                        color: Color.fromRGBO(229, 210, 131, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Episódio: ${episode.episodeNumber}',
                      style: TextStyle(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w200
                      ),
                    ),
                    Text(
                      'Duração: ${episode.runtime != null ? "${episode.runtime} min" : "N/A"}', 
                      style: TextStyle(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w200
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Constants.imagePath}${episode.stillPath ?? ""}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEpisodeOverview(BuildContext context, Episode episode) {
    String _formatAirDate(String? airDate) {
      if (airDate != null) {
        DateTime dateTime = DateTime.parse(airDate);
        return DateFormat('MM/dd/yyyy').format(dateTime);
      } else {
        return 'N/A';
      }
    }
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.name ?? 'Episode Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Data de estreia: ${_formatAirDate(episode.airDate)}',
                  style: TextStyle(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w200
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  episode.overview ?? 'No overview available.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontWeight: FontWeight.w300
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'FECHAR',
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}