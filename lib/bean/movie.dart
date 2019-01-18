import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Autogenerated {
  Rating rating;
  int reviewsCount;
  int wishCount;
  String doubanSite;
  String year;
  Images images;
  String alt;
  String id;
  String mobileUrl;
  String title;
  Object doCount;
  String shareUrl;
  Object seasonsCount;
  String scheduleUrl;
  Object episodesCount;
  List<String> countries;
  List<String> genres;
  int collectCount;
  List<Casts> casts;
  Object currentSeason;
  String originalTitle;
  String summary;
  String subtype;
  List<Directors> directors;
  int commentsCount;
  int ratings_count;
  List<String> aka;

  Autogenerated();
  factory Autogenerated.fromJson(Map<String, dynamic> json) =>
      _$AutogeneratedFromJson(json);
  Map<String, dynamic> toJson() => _$AutogeneratedToJson(this);
}

@JsonSerializable()
class Rating {
  int max;
  double average;
  String stars;
  int min;

  Rating();
  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}

@JsonSerializable()
class Images {
  String small;
  String large;
  String medium;

  Images();
  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Casts {
  String alt;
  Avatars avatars;
  String name;
  String id;

  Casts();
  factory Casts.fromJson(Map<String, dynamic> json) => _$CastsFromJson(json);
  Map<String, dynamic> toJson() => _$CastsToJson(this);
}

@JsonSerializable()
class Avatars {
  String small;
  String large;
  String medium;

  Avatars();
  factory Avatars.fromJson(Map<String, dynamic> json) =>
      _$AvatarsFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarsToJson(this);
}

@JsonSerializable()
class Directors {
  String alt;
  Avatars avatars;
  String name;
  String id;

  Directors();
  factory Directors.fromJson(Map<String, dynamic> json) =>
      _$DirectorsFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorsToJson(this);
}
