import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProgressDialogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProgressDialogState();
  }
}

class ProgressDialogState extends State<ProgressDialogPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('加载弹框'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildButton('加载2秒钟, 弹出成功文案', _click2SecondSuccess),
            buildButton('加载2秒钟, 弹出失败文案', _click2SecondFailed),
            buildButton('添加View', _click2addView),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String name, VoidCallback onclick) {
    return RaisedButton(
      onPressed: onclick,
      child: Text(name),
    );
  }

  /// 加载2秒钟, 弹出成功文案
  void _click2SecondSuccess() {
    ProgressDialog.showProgressDialog(
        context: context,
        future: Future.delayed(Duration(seconds: 2), () {
          Fluttertoast.showToast(msg: '成功', gravity: ToastGravity.CENTER);
        }));
  }

  /// 加载2秒钟, 弹出失败Toast
  void _click2SecondFailed() {
    ProgressDialog.showStateDialog(
        context: context,
        loadingText: '加载成功',
        icon: Icon(
          Icons.check_circle_outline,
          size: 28.0,
          color: Colors.white,
        ));
  }

  /// 添加View
  void _click2addView() {
    Stack(
      children: <Widget>[
        context.widget,
        Center(
          child: Text('sss'),
        )
      ],
    );
  }
}
