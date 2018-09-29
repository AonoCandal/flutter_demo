import 'dart:async';

import 'package:sqflite/sqflite.dart';

class Region {
  int id;
  String name;
  String displayName;
  int parentId;
  int level;
  int lat;
  int lng;
  int status;

  String get showName {
    if (displayName != null && displayName.length > 0) {
      return displayName;
    }

    return name;
  }

  double get longitude {
    return lng / 1000000.0;
  }

  double get latitude {
    return lat / 1000000.0;
  }

  static Region fromMap(Map data) {
    Region region = new Region();

    region.id = data['id'];
    region.name = data['name'];
    region.parentId = data['parent_id'];
    region.level = data['level'];
    region.lat = data['lat'];
    region.lng = data['lng'];
    region.status = data['status'];

    return region;
  }

  Region copyWith() {
    Region region = new Region();
    region.id = this.id;
    region.name = this.name;
    region.parentId = this.parentId;
    region.level = this.level;
    region.lat = this.lat;
    region.lng = this.lng;
    region.status = this.status;
    return region;
  }
}

Future<List<Region>> queryRegionInfo(
    Database db, int level, int parentId, int status) async {
  List<Map> list = await db.rawQuery(
      'SELECT id, name, parent_id, level, lat, lng, status FROM region WHERE status = ? AND level = ? AND parent_id = ?',
      [status, level, parentId]);
  List<Region> regionList = new List();
  list.map((data) {
    if (data != null) {
      Region region = Region.fromMap(data);
      regionList.add(region);
    }
  }).toList();

  return regionList;
}

Future<Region> queryParentRegion(Database db, int parentId, int status) async {
  List<Map> list = await db.rawQuery(
      'SELECT id, name, parent_id, level, lat, lng, status FROM region WHERE status = ? AND id = ?',
      [status, parentId]);

  Region region;
  if (list != null && list.length > 0) {
    region = Region.fromMap(list[0]);
  }
  return region;
}
