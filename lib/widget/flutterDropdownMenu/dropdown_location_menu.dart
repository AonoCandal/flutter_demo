import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/drapdown_common.dart';
import 'package:flutter_demo/widget/flutterDropdownMenu/dropdown_list_menu.dart';
import 'package:flutter_demo/widget/tjport_grid_layout.dart';

class DropdownLocationMenu extends DropdownWidget {
//  final List<String> provinces;

//  DropdownLocationMenu({
//    @required this.provinces,
//  });

  @override
  DropdownState<DropdownWidget> createState() {
    return DropdownLocationMenuState();
  }
}

class DropdownLocationMenuState extends DropdownState<DropdownLocationMenu> {
  bool isProvincePage = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 30.0,
                    color:
                        isProvincePage ? Color(0xFF2196F3) : Color(0xFFF4F6FA),
                    child: Center(
                        child: Text('省',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: isProvincePage
                                    ? Colors.white
                                    : Color(0xff292929)))),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 30.0,
                    color:
                        !isProvincePage ? Color(0xFF2196F3) : Color(0xFFF4F6FA),
                    child: Center(
                        child: Text('市',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: !isProvincePage
                                    ? Colors.white
                                    : Color(0xff292929)))),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Divider(color: Color(0xFF2196F3), height: 0.5),
          Container(
            color: Color(0xffdfdfdf),
            height: 300.0,
            child: ListView(
              children: <Widget>[
                GridLayout(
                  crossAxisCount: 4,
                  widgets: _getRegionWidgetList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onEvent(DropdownEvent event) {
    // TODO: implement onEvent
  }

  List<Widget> _getRegionWidgetList() {
    List<Widget> widgets = [];
    for (int i = 0; i < 80; i++) {
      widgets.add(Container(
        color: Colors.white,
        height: 45.0,
        margin: EdgeInsets.only(top: 0.5, right: 0.25, left: 0.25),
        child: Center(
          child: Text("地址$i",
              style: TextStyle(color: Color(0xff292929), fontSize: 15.0)),
        ),
      ));
    }
    return widgets;
  }
}

class DropdownTreeMenu<T, E> extends DropdownWidget {
  final List<T> data;
  final int selectedIndex;
  final MenuItemBuilder<T> itemBuilder;

  final int subSelectedIndex;
  final MenuItemBuilder<E> subItemBuilder;

  final GetSubData<T, E> getSubData;

  final double itemExtent;

  final Color background;

  final Color subBackground;

  final int flex;
  final int subFlex;

  DropdownTreeMenu({
    this.data,
    double itemExtent,
    this.selectedIndex,
    this.itemBuilder,
    this.subItemBuilder,
    this.getSubData,
    this.background: const Color(0xfffafafa),
    this.subBackground,
    this.flex: 1,
    this.subFlex: 2,
    this.subSelectedIndex,
  })  : assert(getSubData != null),
        itemExtent = itemExtent ?? kDropdownMenuItemHeight;

  @override
  DropdownState<DropdownWidget> createState() {
    return new _TreeMenuList();
  }
}

class _TreeMenuList<T, E> extends DropdownState<DropdownTreeMenu> {
  int _subSelectedIndex;
  int _selectedIndex;

  //
  int _activeIndex;

  List<E> _subData;

  List<T> _data;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _subSelectedIndex = widget.subSelectedIndex;
    _activeIndex = _selectedIndex;

    _data = widget.data;

    if (_activeIndex != null) {
      _subData = widget.getSubData(_data[_activeIndex]);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(DropdownTreeMenu oldWidget) {
    // _selectedIndex = widget.selectedIndex;
    // _subSelectedIndex = widget.subSelectedIndex;
    // _activeIndex = _selectedIndex;

    super.didUpdateWidget(oldWidget);
  }

  Widget buildSubItem(BuildContext context, int index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.subItemBuilder(context, _subData[index],
          _activeIndex == _selectedIndex && index == _subSelectedIndex),
      onTap: () {
        assert(controller != null);
        controller.select(_subData[index],
            index: _activeIndex, subIndex: index);
        setState(() {
          _selectedIndex = _activeIndex;
          _subSelectedIndex = index;
        });
      },
    );
  }

  Widget buildItem(BuildContext context, int index) {
    final List<T> list = widget.data;
    final T data = list[index];
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.itemBuilder(context, data, index == _activeIndex),
      onTap: () {
        //切换
        //拿到数据
        setState(() {
          _subData = widget.getSubData(data);
          _activeIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
            flex: widget.flex,
            child: new Container(
              child: new ListView.builder(
                itemExtent: widget.itemExtent,
                itemBuilder: buildItem,
                itemCount: this._data == null ? 0 : this._data.length,
              ),
              color: widget.background,
            )),
        new Expanded(
            flex: widget.subFlex,
            child: new Container(
              color: widget.subBackground,
              child: new CustomScrollView(
                slivers: <Widget>[
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                    buildSubItem,
                    childCount:
                        this._subData == null ? 0 : this._subData.length,
                  ))
                ],
              ),
            ))
      ],
    );
  }

  @override
  void onEvent(DropdownEvent event) {
    // TODO: implement onEvent
  }
}
