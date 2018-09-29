import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/widget/region_picker/entity/region.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum RegionChoiceType { province, city, county }

const double maxHeightRatio = 7.0 / 8.0;
const Duration _kRegionPickerDuration = const Duration(milliseconds: 200);

class _RegionPickerLayout extends SingleChildLayoutDelegate {
  _RegionPickerLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight * maxHeightRatio);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_RegionPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _RegionPickerRoute<T> extends PopupRoute<T> {
  _RegionPickerRoute({
    this.barrierLabel,
    this.type,
    this.onChanged,
    RouteSettings settings,
  }) : super(settings: settings);

  RegionChoiceType type;
  RegionPickerOnChanged onChanged;

  @override
  Duration get transitionDuration => _kRegionPickerDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = new AnimationController(
      duration: _kRegionPickerDuration,
      debugLabel: 'RegionPicker',
      vsync: navigator.overlay,
    );
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new RegionPicker(route: this, type: type, onChanged: onChanged);
  }
}

Database _regionDB;

typedef void RegionPickerOnChanged(Region region, Database db);

class RegionPicker extends StatefulWidget {
  final _RegionPickerRoute route;
  final RegionChoiceType type;
  final RegionPickerOnChanged onChanged;

  RegionPicker({
    this.route,
    this.type,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _RegionPickerState();
  }

  static void show(BuildContext context,
      {RegionChoiceType type, RegionPickerOnChanged onChanged}) {
    assert(context != null);
    _createDB().then((_) {
      Navigator
          .of(context)
          .push(new _RegionPickerRoute(type: type, onChanged: onChanged));
    });
  }

  static void dismiss(BuildContext context) {
    assert(context != null);
    Navigator.of(context).pop();
  }

  //DB
  static Future _createDB() async {
//    Directory path = await getApplicationDocumentsDirectory();
//    String dbPath = join(path.path, "region.db");
////    String db = await getDatabasesPath();
////    String dbPath = join(db, "region.db");
//    print('database is ${await File(dbPath).exists()}');
//    print('database is ${await File(dbPath).length()}');
//    print('$dbPath');
//    _regionDB = await openDatabase(dbPath, version: 1);

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "region.db");

// try opening (will work if it exists)
    try {
      _regionDB = await openDatabase(path, readOnly: true);
    } catch (e) {
      print("Error $e");
    }

    if (_regionDB == null) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "region.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      // open the database
      _regionDB = await openDatabase(path, readOnly: true);
    }
  }
}

class _RegionPickerState extends State<RegionPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _regionDB = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _regionDB == null
        ? new Container()
        : new GestureDetector(
            onTap: () => Navigator.pop(context),
            child: new AnimatedBuilder(
                animation: widget.route.animation,
                builder: (BuildContext context, Widget child) {
                  return new ClipRect(
                      child: new CustomSingleChildLayout(
                          delegate: new _RegionPickerLayout(
                              widget.route.animation.value),
                          child: new Material(
                              color: Colors.white,
                              child: new RegionPickerWidget(
                                  type: widget.type,
                                  onChanged: widget.onChanged))));
                }));
  }
}

class RegionPickerWidget extends StatefulWidget {
  final RegionChoiceType type;
  final RegionPickerOnChanged onChanged;

  RegionPickerWidget({
    this.type,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _RegionPickerWidgetState();
  }
}

const double _kRegionHorizontalPadding = 15.0;
const Color _kRegionSeparateLineColor = const Color(0xFFDADEE6);
const Color _kRegionDefaultColor = const Color(0xFF1E2533);
const double _kRegionItemFontSize = 14.0;
const int _kRegionItemColumnCount = 4;
const double kRegionItemHeight = 40.0;
const double kRegionItemHeaderHeight = 45.0;

class _RegionPickerWidgetState extends State<RegionPickerWidget> {
  List<Region> currentRegionList = new List();
  Size screenSize;
  int currentLevel = 0;
  Region currentRegion;
  RegionChoiceType type;
  List<int> parentIds = new List();

  @override
  void initState() {
    type = widget.type == null ? RegionChoiceType.county : widget.type;
    _queryRegionInfo(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new GestureDetector(
      child: new SafeArea(
        top: false,
        child: new Container(
            height: kRegionItemHeaderHeight + kRegionItemHeight * 8 + 50.0,
            color: Colors.white,
            child: new Column(children: <Widget>[
              new Container(
                  height: kRegionItemHeaderHeight,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(_getRegionTitle(),
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: _kRegionDefaultColor))),
                      currentLevel != 0
                          ? new GestureDetector(
                              child: new Container(
                                  color: Colors.white,
                                  height: kRegionItemHeaderHeight,
                                  child: new Row(
                                    children: <Widget>[
                                      new Text(
                                        '返回上一级',
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: const Color(0xFF4FA0FB)),
                                      ),
                                      new Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: new Image.asset(
                                              'assets/images/common/icon_location_back.png',
                                              height: 9.0,
                                              width: 18.0))
                                    ],
                                  )),
                              onTap: _backTopLevelAction,
                            )
                          : new Container()
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(_kRegionHorizontalPadding,
                      0.0, _kRegionHorizontalPadding, 0.0)),
              new Expanded(
                  child: new ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                    new Column(children: _buildListViewChildren(context))
                  ])),
              new Container(
                  child: new Column(
                children: <Widget>[
                  new Container(color: _kRegionSeparateLineColor, height: 0.5),
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () {
                              RegionPicker.dismiss(context);
                            },
                            child: const Text('取消',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: _kRegionDefaultColor))))
                  ])
                ],
              ))
            ])),
      ),
      onTap: () {},
    );
  }

  List<Widget> _buildListViewChildren(BuildContext context) {
    List<Widget> list = new List();

    if (currentRegionList == null) {
      return list;
    }

    for (int i = 0;
        i < currentRegionList.length;
        i += _kRegionItemColumnCount) {
      int rowIndex = i ~/ 4;
      list.add(_buildItemRow(rowIndex, i, context));
    }

    return list;
  }

  Widget _buildItemRow(int rowIndex, int regionIndex, BuildContext context) {
    List<Widget> rowItems = new List();
    for (int i = 0; i < _kRegionItemColumnCount; ++i) {
      if (regionIndex + i >= currentRegionList.length) break;
      rowItems.add(_buildRegionItem(rowIndex, i, regionIndex + i, context));
    }

    return new Container(
        padding:
            const EdgeInsets.symmetric(horizontal: _kRegionHorizontalPadding),
        child: new Row(
            children: rowItems, mainAxisAlignment: MainAxisAlignment.start));
  }

  Widget _buildRegionItem(
      int rowIndex, int columnIndex, int regionIndex, BuildContext context) {
    Region region = currentRegionList[regionIndex];
    double itemWidth = (screenSize.width - 2 * _kRegionHorizontalPadding) /
        _kRegionItemColumnCount;
    return new GestureDetector(
        onTap: () {
          _regionItemTapAction(region, context);
        },
        child: new Container(
            color: Colors.white,
            height: kRegionItemHeight,
            width: itemWidth,
            child: new Row(
              children: <Widget>[
                new Container(color: _kRegionSeparateLineColor, width: 0.5),
                new Expanded(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        color: _kRegionSeparateLineColor,
                        height: rowIndex == 0 ? 0.5 : 0.0),
                    new Expanded(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          new Text(region.showName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: _kRegionItemFontSize,
                                  color: _kRegionDefaultColor))
                        ])),
                    new Container(
                        color: _kRegionSeparateLineColor, height: 0.5),
                  ],
                )),
                new Container(
                    color: _kRegionSeparateLineColor,
                    width: (columnIndex == _kRegionItemColumnCount - 1 ||
                            regionIndex == currentRegionList.length - 1)
                        ? 0.5
                        : 0.0)
              ],
            )));
  }

  //private
  String _getRegionTitle() {
    String title = '当前位置：';
    if (currentLevel == 0) {
      title = '请选择省份：';
    } else if (currentLevel == 1) {
      title = '当前所在省份：' + (currentRegion == null ? '' : currentRegion.name);
    } else if (currentLevel == 2) {
      title = '当前位置：' + (currentRegion == null ? '' : currentRegion.name);
    }
    return title;
  }

  void _queryRegionInfo(int parentId) {
    queryRegionInfo(_regionDB, currentLevel, parentId, 1).then((list) {
      setState(() {
        if ((list == null || list.length == 0) && currentLevel == 2) {
          List<Region> regions = List<Region>();
          Region r = currentRegion.copyWith();
          r.displayName = '全' + r.name;
          r.level = currentLevel;
          regions.add(r);
          currentRegionList = regions;
        } else {
          currentRegionList = list;
        }
      });
    });
  }

  int _levelFromChoiceType() {
    if (type == RegionChoiceType.province) {
      return 0;
    } else if (type == RegionChoiceType.city) {
      return 1;
    } else {
      return 2;
    }
  }

  //Action
  void _backTopLevelAction() {
    currentLevel -= 1;
    _queryRegionInfo(parentIds.last);
    parentIds.removeLast();
  }

  void _regionItemTapAction(Region region, BuildContext context) {
    if (_levelFromChoiceType() == region.level) {
      if (widget.onChanged != null) {
        widget.onChanged(region, _regionDB);
      }
      RegionPicker.dismiss(context);
    } else {
      parentIds.add(region.parentId);
      currentLevel += 1;
      currentRegion = region.copyWith();
      _queryRegionInfo(region.id);
    }
  }
}
