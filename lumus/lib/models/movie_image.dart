class MovieImage{
  int? id;
  String? filepath;
  String? iso;
  int? width;
  int? height;

  MovieImage({
    required this.id,
    required this.filepath,
    required this.iso,
    required this.width,
    required this.height
  });

  factory MovieImage.fromJson(Map<String, dynamic> json) {
    return MovieImage(
      id: json["id"],
      filepath: json["file_path"],
      iso: json["iso_639_1"],
      width: json["width"],
      height: json["height"]
    );
  }  
}