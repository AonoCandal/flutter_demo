import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/list_entity.dart';
import 'package:flutter_demo/page/empty_detail_page.dart';
import 'package:flutter_demo/widget/empty_view.dart';

const int PAGE_SIZE = 20;

class EmptyViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmptyViewPageState();
  }
}

class EmptyViewPageState extends State<EmptyViewPage> {
  EmptyController _controller;
  ScrollController _scrollController;

  int _start = 0;
  List<Movie> _items = [];
  bool loadOver = false;

  @override
  void initState() {
    _controller = EmptyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EmptyView'),
      ),
      backgroundColor: Color(0xffeeeeee),
      body: EmptyView<List<Movie>>(
        future: refresh,
        controller: _controller,
        emptyJudge: (value) {
          return (value as List).length == 0;
        },
        netWorkErrorJudge: (error) {
          print(error);
          return (error is Exception);
        },
        usePlaceHolder: true,
        buildBody: (items) {
          if (items is List<Movie>) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == items.length) {
                      if (loadOver) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('没有更多东西了'),
                          ),
                        );
                      } else {
                        loadMore();
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                    return GestureDetector(
                      onTap: () => Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (context) {
                            return MovieDetailPage();
                          })),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              items[index].images.small,
                              width: 90.0,
                              height: 90.0,
                            ),
                            Container(width: 10.0),
                            Expanded(
                              child: Text(
                                items[index].title,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  final String url = "http://api.douban.com/v2/movie/top250";
  Dio dio = Dio();

  Future<List<Movie>> refresh() {
    _start = 0;
    Completer<List<Movie>> completer = Completer();
    _getItem(_start).then((items) {
      setState(() {
        _items.clear();
        _items.addAll(items);
        _start = _items.length;
        completer.complete(_items);
        loadOver = items.length < PAGE_SIZE;
      });
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<List<Movie>> loadMore() {
    Completer<List<Movie>> completer = Completer();
    _getItem(_start).then((items) {
      setState(() {
        _items.addAll(items);
        _start = _items.length;
        completer.complete(_items);
        loadOver = items.length < PAGE_SIZE;
      });
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<List<Movie>> _getItem(int start) async {
    var result;
    try {
      Response response =
          await dio.post(url, data: {"start": start, "count": PAGE_SIZE});
      print(response.toString());
      if (response.statusCode == HttpStatus.ok) {
        result = response.data;
      } else {
        result = "error $response.statusCode";
      }
    } on HttpException catch (e) {
      result = e.message;
    }
    ListEntity listEntity = ListEntity.fromJson(result as Map<String, dynamic>);
    return listEntity.subjects;
  }
}
