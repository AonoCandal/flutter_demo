import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/progress_dialog.dart';

class ProgressDialogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProgressDialogState();
  }
}

class ProgressDialogState extends State<ProgressDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('加载弹窗 & 状态弹窗'),
      ),
      body: ListView(
        children: [
          _listItem(
              '加载2秒钟',
              () => ProgressDialog.showProgressDialog(
                  context: context,
                  future: Future.delayed(Duration(seconds: 2)))),
          _listItem('弹出成功状态2秒钟',
              () => ProgressDialog.showSuccessDialog(context: context)),
          _listItem(
              '弹出自定义状态弹框',
              () => ProgressDialog.showStateDialog(
                  context: context,
                  loadingText: '警告',
                  icon: Icon(
                    Icons.error,
                    size: kDefaultIconSize,
                    color: Colors.white,
                  ))),
          _listItem(
              '加载2秒钟之后弹出成功',
              () => ProgressDialog.showProgressDialog(
                    context: context,
                    future: Future.delayed(Duration(seconds: 2)).then((value) {
                      ProgressDialog.showSuccessDialog(context: context);
                    }),
                  )),
          _listItem(
              '加载2秒钟之后弹出失败',
              () => ProgressDialog.showProgressDialog(
                    context: context,
                    future: Future.delayed(Duration(seconds: 2)).then((value) {
                      ProgressDialog.showFailDialog(context: context);
                    }),
                  )),
          _listItem(
              '异步加载并随机捕获错误(仿实际使用)',
              () => ProgressDialog.showProgressDialog(
                  context: context,
                  future: Future.delayed(Duration(seconds: 2), () {
                    Random r = Random();
                    if (!r.nextBool()) {
                      throw Exception();
                    }
                  }).then((value) {
                    ProgressDialog.showSuccessDialog(context: context);
                  }).catchError((e) {
                    ProgressDialog.showFailDialog(context: context);
                  }))),
        ],
      ),
    );
  }

  Widget _listItem(String title, VoidCallback listener) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: listener,
    );
  }
}
