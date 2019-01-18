// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListEntity _$ListEntityFromJson(Map<String, dynamic> json) {
  return ListEntity()
    ..count = json['count'] as int
    ..start = json['start'] as int
    ..total = json['total'] as int
    ..subjects = (json['subjects'] as List)
        ?.map(
            (e) => e == null ? null : Movie.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ListEntityToJson(ListEntity instance) =>
    <String, dynamic>{
      'count': instance.count,
      'start': instance.start,
      'total': instance.total,
      'subjects': instance.subjects
    };

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie()
    ..title = json['title'] as String
    ..images = json['images'] == null
        ? null
        : ImageEntity.fromJson(json['images'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovieToJson(Movie instance) =>
    <String, dynamic>{'title': instance.title, 'images': instance.images};

ImageEntity _$ImageEntityFromJson(Map<String, dynamic> json) {
  return ImageEntity()..small = json['small'] as String;
}

Map<String, dynamic> _$ImageEntityToJson(ImageEntity instance) =>
    <String, dynamic>{'small': instance.small};
