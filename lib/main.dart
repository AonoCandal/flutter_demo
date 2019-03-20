import 'package:flutter/material.dart';
import 'package:flutter_demo/page/calendar_page.dart';
import 'package:flutter_demo/page/empty_layout_page.dart';
import 'package:flutter_demo/page/empty_view_page.dart';
import 'package:flutter_demo/page/home_page.dart';
import 'package:flutter_demo/page/image_page.dart';
import 'package:flutter_demo/page/life_cycle_page.dart';
import 'package:flutter_demo/page/list_in_list_page.dart';
import 'package:flutter_demo/page/my_home_page.dart';
import 'package:flutter_demo/page/progress_dialog_page.dart';
import 'package:flutter_demo/page/pull_to_refresh/pull_to_refresh_page.dart';
import 'package:flutter_demo/page/search_page.dart';
import 'package:flutter_demo/page/search_page_2.dart';

import 'page/letterpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/a': (_) => ImagePage(),
        '/b': (_) => LetterPage("B"),
        '/c': (_) => LetterPage("C"),
        '/home': (_) => HomePage(),
        '/myhome': (_) => MyHomePage(title: 'lalalla'),
        '/lifecycle': (_) => LifeCyclePage(),
        '/calendar': (_) => CalendarPage(),
        '/ListinList': (_) => ListInListPage(),
        '/EmptyLayout': (_) => EmptyLayoutPage(),
        '/ProgressDialog': (_) => ProgressDialogPage(),
        '/EmptyView': (_) => EmptyViewPage(),
        '/pullToRefresh': (_) => PullToRefreshPage(),
        '/searchPage': (_) => SearchPage(),
        '/searchPage2': (_) => SearchPage2(),
      },
    );
  }
}
