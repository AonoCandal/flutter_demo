import 'package:flutter/material.dart';
import 'package:flutter_demo/page/calendar_page.dart';
import 'package:flutter_demo/page/home_page.dart';
import 'package:flutter_demo/page/image_page.dart';
import 'package:flutter_demo/page/life_cycle_page.dart';
import 'package:flutter_demo/page/my_home_page.dart';

import 'page/letterpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        '/a': (_) => new ImagePage(),
        '/b': (_) => new LetterPage("B"),
        '/c': (_) => new LetterPage("C"),
        '/home': (_) => new HomePage(),
        '/myhome': (_) => new MyHomePage(title: 'lalalla'),
        '/lifecycle': (_) => new LifeCyclePage(),
        '/calendar': (_) => new CalendarPage(),
      },
    );
  }
}
