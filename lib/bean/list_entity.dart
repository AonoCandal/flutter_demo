import 'package:json_annotation/json_annotation.dart';

part 'list_entity.g.dart';
// ignore: part_of_non_part

@JsonSerializable()
class ListEntity {
  int count;
  int start;
  int total;
  List<Movie> subjects;

  ListEntity();
  factory ListEntity.fromJson(Map<String, dynamic> json) =>
      _$ListEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ListEntityToJson(this);
}

@JsonSerializable()
class Movie {
  Movie();
  String title;
  ImageEntity images;
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class ImageEntity {
  ImageEntity();
  String small;
  factory ImageEntity.fromJson(Map<String, dynamic> json) =>
      _$ImageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ImageEntityToJson(this);
}
