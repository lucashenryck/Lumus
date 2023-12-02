class Episode {
  String? airDate;
  int? episodeNumber;
  String? name;
  String? overview;
  String? productionCode;
  int? seasonNumber;
  String? stillPath;
  double? voteAverage;
  int? voteCount;
  int? runtime;

  Episode({
    required this.airDate,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    required this.runtime
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      airDate: json["air_date"],
      episodeNumber: json["episode_number"],
      name: json["name"],
      overview: json["overview"],
      productionCode: json["production_code"],
      seasonNumber: json["season_number"],
      stillPath: json["still_path"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
      runtime: json["runtime"]
    );
  }
}