import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/http/http.dart';

class LetterPage extends StatefulWidget {
  @required
  final String title;

  LetterPage(this.title);

  @override
  State<StatefulWidget> createState() {
    return new LetterPageState();
  }
}

class LetterPageState extends State<LetterPage> {
  static const platform = const MethodChannel("com.aono/battery");
  String _batteryLevel = 'Unknow battery level';

  String _IPAddress = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            onPressed: _getBatteryLevel,
            icon: new Icon(Icons.battery_unknown),
          ),
          new IconButton(
            onPressed: _getIPAddress,
            icon: new Icon(Icons.location_on),
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Center(
            child: new GestureDetector(
              child: new Text("这是详情页$widget.title"),
              onTap: () {
                Navigator.pop(context, "刚刚从详情页$widget.title回来");
              },
            ),
          ),
          new Center(
              child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.battery_std),
              new Text(_batteryLevel),
            ],
          )),
          new Text(_IPAddress),
        ],
      ),
    );
  }

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod("getBatteryLevel");
      batteryLevel = 'Battery level at $result %';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future _getIPAddress() async {

    var result = await WLHttp().get();
    setState(() {
      _IPAddress = result;
    });
  }
}
