class SoundsList {}

class SoundTopData {
  int count;
  String next;
  List<SoundsDetailedResult> results;

  SoundTopData({
    required this.count,
    required this.next,
    required this.results,
  });

  factory SoundTopData.fromJson(Map<String, dynamic> json) => SoundTopData(
        count: json["count"],
        next: json["next"],
        results: List<SoundsDetailedResult>.from(
            json["results"].map((x) => SoundsDetailedResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class SoundsDetailedResult {
  int id;
  String name;
  List<String> tags;
  String license;
  String username;

  SoundsDetailedResult({
    required this.id,
    required this.name,
    required this.tags,
    required this.license,
    required this.username,
  });

  factory SoundsDetailedResult.fromJson(Map<String, dynamic> json) =>
      SoundsDetailedResult(
        id: json["id"],
        name: json["name"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        license: json["license"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "license": license,
        "username": username,
      };
}
