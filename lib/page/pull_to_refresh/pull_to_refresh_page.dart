import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/bloc/provider/bloc_provider.dart';
import 'package:flutter_demo/page/pull_to_refresh/pull_to_refresh_bloc.dart';

class PullToRefreshPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PullToRefreshState();
  }
}

class PullToRefreshState extends State<PullToRefreshPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PullToRefreshPage'),
      ),
      body: buildBody(),
    );
  }

  Future<List> _refresh() {
    Completer completer = Completer();
    Future.delayed(Duration(seconds: 1), () {
      completer.complete(List(20));
    });
    return completer.future;
  }

  Widget buildBody() {
    return BlocProvider<PullToRefreshBloc>(
      bloc: PullToRefreshBloc(),
      child: Container(),
    );
  }
}
