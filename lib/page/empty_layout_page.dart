import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/page/bloc/bloc_empty_layout.dart';

class EmptyLayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EmptyLayout"),
        centerTitle: true,
      ),
      body: EmptyLayout(),
    );
  }
}

class EmptyLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyLayoutState();
}

class EmptyLayoutState extends State<EmptyLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EmptyLayoutProvider(
      child: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemBuilder: (context, index) => Text('kskskksksks'),
                itemCount: 100,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bloc: new EmptyLayoutBloc(),
    );
  }

  Future<void> _onRefresh() {
    Completer<void> completer = new Completer();
    return completer.future;
  }
}
