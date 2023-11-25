class CastAndCrew{
  int? id;
  String? knownForDepartment;
  String? name;
  String? profilePath;
  String? character;
  String? job;

  CastAndCrew({
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.profilePath,
    required this.character,
    required this.job
  });

  factory CastAndCrew.fromJson(Map<String, dynamic> json) {
    return CastAndCrew(
      id: json["id"],
      knownForDepartment: json["know_for_department"],
      name: json["name"],
      profilePath: json["profile_path"],
      character: json["character"],
      job: json["job"]
    );
  }  
}