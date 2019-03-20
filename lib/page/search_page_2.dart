import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/search_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPage2State();
  }
}

class SearchPage2State extends State<SearchPage2> {
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
        title: const Text(
          '二级标题',
          style: TextStyle(color: Color(0xff333333), fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchWidget(
                controller: _controller,
                onSubmitted: _onSearchClick,
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight),
        ),
      ),
    );
  }

  void _onSearchClick(String text) {
    Fluttertoast.showToast(msg: text);
  }
}
