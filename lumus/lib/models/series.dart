class Series {
  int? id;
  String name;
  String backDropPath;
  String originalName;
  String overview;
  String posterPath;
  String firstAirDate;

  Series({
    required this.id,
    required this.name,
    required this.backDropPath,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      name: json["name"],
      backDropPath: json["backdrop_path"],
      originalName: json["original_name"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      firstAirDate: json["first_air_date"]
    );
  }  
}