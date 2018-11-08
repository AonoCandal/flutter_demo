import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/notify/notify_manager.dart';
import 'package:flutter_demo/widget/tjport_step_route_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> implements NotifyListener {
  AudioCache audioCache = new AudioCache();

  List<TJPortStepRoute> list = [
    new TJPortStepRoute(
      status: stepStatus['提'],
      mainAddress: '河北省石家庄市长安区',
      subAddress: '河北省石家庄市长安区新乐返藁城啊实打实大',
      timeDescription: '06-20 19:00',
    ),
    new TJPortStepRoute(
      status: stepStatus['配箱'],
      mainAddress: '河北省石家庄市长安区',
      subAddress: '河北省石家庄市长安区新乐返藁城啊实打实大',
      timeDescription: '06-21 19:00',
    ),
    new TJPortStepRoute(
      status: stepStatus['运'],
      mainAddress: '河北省石家庄市长安区',
      subAddress: '河北省石家庄市长安区新乐返藁城啊实打实大',
      timeDescription: '06-22 19:00',
    ),
    new TJPortStepRoute(
      status: stepStatus['抵'],
      mainAddress: '河北省石家庄市长安区',
      subAddress: '河北省石家庄市长安区新乐返藁城啊实打实大',
      timeDescription: '06-23 19:00',
    ),
  ];

  @override
  void initState() {
    print("home_page_initState");
    super.initState();
    onRefresh();
    NotifyManager.getInstance().addListener('show_dialog', this);
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    print("home_page_didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("home_page_didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("home_page_deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("home_page_dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("home_page_build");
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildButton("myhomePage", '/myhome'),
                _buildButton("lifeCycle", '/lifecycle'),
                _buildButton("calendar", '/calendar'),
              ],
            )
          ],
        ),
        onRefresh: onRefresh);
  }

  Widget _buildButton(String label, String router) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: RaisedButton(
          child: Text(label),
          onPressed: () => Navigator.of(context).pushNamed(router)),
    );
  }

  Future<Null> onRefresh() async {
    print("home_page_onRefresh");
    Completer<Null> completer = new Completer();
    Future.delayed(Duration(seconds: 2))
        .then((_) {
          print("home_page_onRefresh_success");
        })
        .catchError(() {})
        .whenComplete(() {
          completer.complete(null);
        });
    return completer.future;
  }

  @override
  void onUpdate(String name, object) {
    Map<String, dynamic> codes =
        json.decode("{\"1\":\"lalal\", \"2\":\"nonono\"}");
    Map<int, String> oilCodes = {};
    print("encode oil map :" + codes.toString());
    codes.forEach((key, value) {
      try {
        oilCodes[int.parse(key)] = value;
      } catch (e) {
        return;
      }
    });
    print("encode oil map :" + oilCodes.toString());

    print("home_page_onUpdate");
    audioCache.play('audio.mp3');
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (buildContext) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0.0),
            children: <Widget>[
              // head  goods info
              Stack(
                children: <Widget>[
                  // bg
                  Image.asset(
                    'images/bg_dialog_head.png',
                    fit: BoxFit.fill,
                    height: 85.0,
                  ),
                  // goods info
                  Container(
                    height: 85.0,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '1*40GP / 28吨 / 28吨 / 15件 / 家具家电',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                        Container(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '进口',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Container(width: 20.0),
                            Text(
                              '明天 下午 14:00',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // way bill station status
              Stack(
                children: <Widget>[
                  TJPortStepRouteWidget(list),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 30.0,
                      width: 50.0,
                      alignment: Alignment.center,
                      color: Colors.deepOrange,
                      child: Text('待提箱'),
                    ),
                  ),
                ],
              ),

              // accept btn
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                  color: Color(0xFF2196F3),
                  onPressed: () => Navigator.pop(context, true),
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text(
                      '我知道了',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
