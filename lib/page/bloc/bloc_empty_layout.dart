import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EmptyLayoutProvider extends InheritedWidget {
  final EmptyLayoutBloc bloc;

  EmptyLayoutProvider({
    Key key,
    Widget child,
    this.bloc,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static EmptyLayoutBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EmptyLayoutProvider)
            as EmptyLayoutProvider)
        .bloc;
  }
}

class EmptyLayoutBloc {
  /// 用于内部使用的Stream
  StreamController<int> _refreshController = new StreamController();

  /// 用于外部事件触发
  StreamSink<int> get rfControllerSink => _refreshController.sink;

  /// 用于自身事件监听
  Stream<int> get _rfControllerStream => _refreshController.stream;

  ///****************************************************

  /// 用户给外部使用的Stream
  BehaviorSubject<List<String>> _refreshBehavior = new BehaviorSubject();

  /// 用于自身事件流刷新
  StreamSink get _refreshSink => _refreshBehavior.sink;

  /// 给外部提供数据
  Stream<List<String>> get refreshStream => _refreshBehavior.stream;

  EmptyLayoutBloc() {
    initData();
  }

  void initData() {
    _rfControllerStream.listen((index) {
      _fetchData(index: index).then((list) => _refreshSink.add(list));
    });
  }

  dispose() {
    /// 关闭两种流
    _refreshController.close();
    _refreshBehavior.close();
  }

  refresh() {
    rfControllerSink.add(0);
  }

  loadMore() {
    rfControllerSink.add(20);
  }

  Future<List<String>> _fetchData({int index = 0}) {
    return Future.delayed(Duration(seconds: 1)).then((_) {
      List<String> list = [];
      for (int i = index; i < 20 + index; i++) {
        list.add("第$i行");
      }
      print('request: $index ~ ${index + 20}');
      return list;
    });
  }
}
