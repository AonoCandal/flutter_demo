import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                new Image.asset("images/bg.png"),
              ],
            )),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: new Text("ssss"),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: <Widget>[
              FlatButton(
                  onPressed: () => _onClick(context), child: Text("lalal"))
            ],
          ),
        )
      ],
    );
  }

  _onClick(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(),
//            bottomSheet: new BottomSheet(onClosing: null, builder: null),
            body: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('设置支付密码'),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
