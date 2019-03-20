import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/search_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: SearchWidget(
          controller: _controller,
          onSubmitted: _onSearchClick,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: InkWell(
              onTap: () => _onSearchClick(_controller.text),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    '搜索',
                    style: TextStyle(color: Color(0xff333333), fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchClick(String text) {
    Fluttertoast.showToast(msg: text);
  }
}
