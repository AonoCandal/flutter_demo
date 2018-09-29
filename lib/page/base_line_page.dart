import 'package:flutter/material.dart';

class BaseLinePage extends StatefulWidget {
  @required
  final String title;

  BaseLinePage(this.title);

  @override
  State<StatefulWidget> createState() {
    return new BaseLinePageState();
  }
}

class BaseLinePageState extends State<BaseLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Baseline(
                baseline: 50.0,
                baselineType: TextBaseline.alphabetic,
                child: Text("888888",
                    style: TextStyle(
                        fontSize: 30.0, textBaseline: TextBaseline.alphabetic)),
              ),
              Baseline(
                baseline: 50.0,
                baselineType: TextBaseline.alphabetic,
                child: Text("888888",
                    style: TextStyle(
                        fontSize: 10.0, textBaseline: TextBaseline.alphabetic)),
              ),
              Container(
                color: Colors.grey,
                width: 1.0,
                height: 100.0,
              ),
              Baseline(
                baseline: 50.0,
                baselineType: TextBaseline.alphabetic,
                child: Text("888888",
                    style: TextStyle(
                        fontSize: 20.0, textBaseline: TextBaseline.alphabetic)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
