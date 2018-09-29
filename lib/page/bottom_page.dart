import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/oil_list_page.dart';
import 'package:flutter_demo/page/review_images_page.dart';

class BottomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomState();
  }
}

class BottomState extends State<BottomPage> {
  int _tabIndex = 0;
  var tabImages;
  var _bodies;
  var appBarTitles = ['抢单', '任务', '我的'];

  Image getTabIcon(int currentIdx) {
    if (currentIdx == _tabIndex) {
      return tabImages[currentIdx][1];
    }
    return tabImages[currentIdx][0];
  }

  Text getTabTitle(int currentIdx) {
    if (currentIdx == _tabIndex) {
      return Text(
        appBarTitles[currentIdx],
        style: TextStyle(color: Color(0xFF1F2533), fontSize: 12.0),
      );
    }
    return Text(
      appBarTitles[currentIdx],
      style: TextStyle(color: Color(0xFFA1A7B3), fontSize: 12.0),
    );
  }

  initTabs() {
    tabImages = [
      [
        new Image.asset(
          'images/rush_nor.png',
          height: 20.0,
          width: 20.0,
        ),
        new Image.asset(
          'images/rush_sel.png',
          height: 20.0,
          width: 20.0,
        ),
      ],
      [
        new Image.asset(
          'images/task_nor.png',
          height: 20.0,
          width: 20.0,
        ),
        new Image.asset(
          'images/task_sel.png',
          height: 20.0,
          width: 20.0,
        ),
      ],
      [
        new Image.asset(
          'images/my_nor.png',
          height: 20.0,
          width: 20.0,
        ),
        new Image.asset(
          'images/my_sel.png',
          height: 20.0,
          width: 20.0,
        ),
      ],
    ];
    _bodies = [
      new OilListPage(),
      new ReviewImagesPage([
        'https://upload-images.jianshu.io/upload_images/1913040-4470e7e9bf4328e2.png',
        'https://upload-images.jianshu.io/upload_images/1913040-f9a51ca5e5142672.png'
      ]),
      new ReviewImagesPage([
        'https://upload-images.jianshu.io/upload_images/1913040-4470e7e9bf4328e2.png',
        'https://upload-images.jianshu.io/upload_images/1913040-f9a51ca5e5142672.png'
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    initTabs();
    return Scaffold(
      body: _bodies[_tabIndex],
      bottomSheet: CupertinoTabBar(
        items: [
          new BottomNavigationBarItem(
              icon: getTabIcon(0), title: getTabTitle(0)),
          new BottomNavigationBarItem(
              icon: getTabIcon(1), title: getTabTitle(1)),
          new BottomNavigationBarItem(
              icon: getTabIcon(2), title: getTabTitle(2)),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() => _tabIndex = index);
        },
      ),
    );
  }
}
