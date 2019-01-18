import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/movie.dart';
import 'package:flutter_demo/widget/empty_view.dart';

class MovieDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieDetailState();
  }
}

class MovieDetailState extends State<MovieDetailPage> {
  String title = '';
  Dio dio = Dio();

  String url = 'http://api.douban.com/v2/movie/subject/26942674';

  EmptyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EmptyController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: EmptyView<Autogenerated>(
        usePlaceHolder: true,
        controller: _controller,
        future: _future,
        buildBody: buildBody,
      ),
    );
  }

  Widget buildBody(data) {
    Autogenerated detail = data as Autogenerated;
    int stars = detail.rating.average.round() ~/ 2;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
            child: Text(
              '${detail.title}',
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star,
                            color: stars < 1 ? Colors.grey : Colors.orange,
                            size: 18.0),
                        Icon(Icons.star,
                            color: stars < 2 ? Colors.grey : Colors.orange,
                            size: 18.0),
                        Icon(Icons.star,
                            color: stars < 3 ? Colors.grey : Colors.orange,
                            size: 18.0),
                        Icon(Icons.star,
                            color: stars < 4 ? Colors.grey : Colors.orange,
                            size: 18.0),
                        Icon(Icons.star,
                            color: stars < 5 ? Colors.grey : Colors.orange,
                            size: 18.0),
                        Container(width: 3.0),
                        Text('${detail.rating.average}',
                            style: TextStyle(fontSize: 16.0)),
                        Container(width: 5.0),
                        Text('${detail.ratings_count}人评价',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey)),
                      ],
                    ),
                    Container(height: 10.0),
                    Text('${detail.summary}'),
                  ],
                ),
              ),
              Image.network(
                detail.images.small,
                width: 100.0,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text('演员',
                style: TextStyle(color: Colors.grey, fontSize: 16.0)),
          ),
          Container(
            height: 100.0,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.network(detail.casts[index].avatars.small),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: detail.casts.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 0.5),
          ),
          RaisedButton(
            onPressed: () {
              _controller.changeStatus(Status.loading);
              _future();
            },
            child: Text('reload page'),
          )
        ],
      ),
    );
  }

  Future<Autogenerated> _future() async {
    var result;
    try {
      Response response = await dio.post(url);
      print(response.toString());
      if (response.statusCode == HttpStatus.ok) {
        result = response.data;
      } else {
        result = "error $response.statusCode";
      }
    } on HttpException catch (e) {
      result = e.message;
    }
    Autogenerated movie =
        Autogenerated.fromJson(result as Map<String, dynamic>);
    setState(() => title = movie.title);
    return movie;
  }
}