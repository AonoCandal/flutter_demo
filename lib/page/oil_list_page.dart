import 'package:flutter/material.dart';
import 'package:flutter_demo/page/letterpage.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/drapdown_common.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_header.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_list_menu.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_location_menu.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_menu.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_sliver.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_templates.dart';
import 'package:flutter_demo/widget/region_picker/region_picker.dart';

class OilListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OilListState();
  }
}

const int OIL_INDEX = 0;
const List<Map<String, dynamic>> OIL_TYPE = [
  {"title": "0#"},
  {"title": "1#"},
  {"title": "2#"},
];

const int LOC_INDEX = 0;
const List<Map<String, dynamic>> LOCATION = [
  {"title": "北京"},
  {"title": "四川"},
  {"title": "河北"},
  {"title": "辽宁"},
];

class OilListState extends State<OilListPage> {
  List<String> list = [];
  final double headerHeight = 89.0;
  ScrollController _scrollController;
  GlobalKey _globalKey;

  @override
  void initState() {
    _scrollController = new ScrollController();
    _globalKey = new GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        title: Text('附近油站'),
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultDropdownMenuController(
      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
        print(
            "menuIndex:$menuIndex index:$index subIndex:$subIndex data:$data");
      },
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                key: _globalKey,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return buildOilHeader();
                  },
                  childCount: 1,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: DropdownSliverChildBuilderDelegate(
                  builder: (context) {
                    return Container(
                      child: buildDropdownHeader(onTap: this._onTapHead),
                      color: Colors.white,
                    );
                  },
                ),
              ),
              new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return buildOilItem(index);
              }, childCount: 10)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 46.0),
            child: buildDropdownMenu(),
          ),
        ],
      ),
    );
  }

  /// 创建下拉菜单
  buildDropdownMenu() {
    return DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10, menus: [
      DropdownMenuBuilder(builder: (context) {
        return DropdownLocationMenu();
      }),
      DropdownMenuBuilder(builder: (context) {
        return new DropdownListMenu(
          selectedIndex: OIL_INDEX,
          data: OIL_TYPE,
          itemBuilder: buildCheckItem,
        );
      }),
    ]);
  }

  /// 创建加油头部
  Widget buildOilHeader() {
    return new Container(
      margin: EdgeInsets.only(bottom: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildOilHeaderModule(
              'images/my_sel.png', '扫一扫', () => _gotoScanPage()),
          _buildOilHeaderModule(
              'images/rush_sel.png', '订单', () => _gotoOrderPage()),
          _buildOilHeaderModule(
              'images/task_sel.png', '账户', () => _gotoAccountPage()),
        ],
      ),
    );
  }

  /// 创建下拉菜单头
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [LOCATION[LOC_INDEX], OIL_TYPE[OIL_INDEX]],
    );
  }

  /// 下拉菜单点击事件动画处理
  void _onTapHead(int index) {
    RenderObject renderObject = _globalKey.currentContext.findRenderObject();
    DropdownMenuController controller =
        DefaultDropdownMenuController.of(_globalKey.currentContext);
    _scrollController
        .animateTo(
            _scrollController.offset + renderObject.semanticBounds.height,
            duration: new Duration(milliseconds: 150),
            curve: Curves.ease)
        .whenComplete(() {
      print('show');
      controller.show(index);
    });
  }

  /// 创建油站item
  Widget buildOilItem(int index) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 12.5),
        child: FlatButton(
            padding: EdgeInsets.all(16.0),
            onPressed: _gotoOilDetailPage,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    'http://pic32.photophoto.cn/20140701/0009021116429016_b.jpg',
                    height: 70.0,
                    width: 70.0,
                    fit: BoxFit.fill,
                  ),
                  Container(width: 12.0),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text('四川成都新都区加油站',
                            style: TextStyle(
                                color: Color(0xff292929),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                        Container(height: 12.0),
                        Text('距离 3.8km',
                            style: TextStyle(
                                color: Color(0xff7a7a7a), fontSize: 14.0)),
                        Container(height: 15.0),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '¥ 5.78',
                              style: TextStyle(
                                  color: Color(0xfff7703f),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '/升',
                              style: TextStyle(
                                  color: Color(0xff292929), fontSize: 14.0))
                        ]))
                      ]))
                ])));
  }

  /// 创建油品头部模块
  Widget _buildOilHeaderModule(
      String iconUrl, String name, VoidCallback onPress) {
    return Expanded(
      child: FlatButton(
        padding: EdgeInsets.only(top: 17.0, bottom: 16.0),
        onPressed: onPress,
        child: Column(
          children: <Widget>[
            Image.asset(
              iconUrl,
              color: Color(0xff2196F3),
              width: 26.0,
              height: 26.0,
            ),
            Container(height: 7.5),
            Text(
              '${name ?? ''}',
              style: TextStyle(fontSize: 14.0, color: Color(0xff2196F3)),
            )
          ],
        ),
      ),
    );
  }

  _gotoScanPage() {
    // todo: 去扫一扫页面
  }

  _gotoOrderPage() {
    // todo: 去订单页面
  }

  _gotoAccountPage() {
    // todo: 去账户页面
    RegionPicker.show(context);
  }

  _gotoOilDetailPage() {
    // todo: 去油站详情页面
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new LetterPage('D');
    }));
  }
}
