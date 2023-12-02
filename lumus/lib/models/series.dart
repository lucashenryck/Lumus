class Series {
  int? id;
  String? name;
  String? originalName;
  String? backDropPath;
  String? tagline;
  String? overview;
  String? posterPath;
  String? firstAirDate;
  String? lastAirDate;
  List<CreatedBy>? createdBy;
  List<Genre>? genres;
  int? numberOfEps;
  int? numberOfSeasons;
  List<Season>? seasons;

  Series({
    required this.id,
    required this.name,
    required this.originalName,
    required this.tagline,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.createdBy,
    required this.genres,
    required this.lastAirDate,
    required this.numberOfEps,
    required this.numberOfSeasons,
    required this.seasons
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      name: json["name"],
      backDropPath: json["backdrop_path"],
      originalName: json["original_name"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      firstAirDate: json["first_air_date"],
      tagline: json["tagline"],
      createdBy: (json['created_by'] as List<dynamic>?)
          ?.map((item) => CreatedBy.fromJson(item))
          .toList(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((item) => Genre.fromJson(item))
          .toList(),
      lastAirDate: json['last_air_date'],
      numberOfEps: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((item) => Season.fromJson(item))
          .toList(),
    );
  }  
}

class CreatedBy {
  int? id;
  String? creditId;
  String? name;
  int? gender;
  String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["id"],
      creditId: json["credit_id"],
      name: json["name"],
      gender: json["gender"],
      profilePath: json["profile_path"],
    );
  }
}

class Genre {
  String? name;

  Genre({
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      name: json["name"],
    );
  }
}

class Season {
  String? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      airDate: json["air_date"],
      episodeCount: json["episode_count"],
      id: json["id"],
      name: json["name"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      seasonNumber: json["season_number"],
    );
  }
}