import 'package:flutter/material.dart';
import 'package:flutter_demo/page/bottom_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool _offstage = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) {
            return new Scaffold(
              appBar: new AppBar(
                title: new Text("page"),
              ),
              body: new Center(
                child: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("pop"),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String _inputText = "ss";
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: new Image.asset(
                  "images/bg.png",
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomPage();
                  }));
                },
              ),
              new TextField(
                decoration: InputDecoration(
                  icon: new Icon(Icons.face),
                  prefixIcon: Text("sasda "),
                  errorText: "error",
                  hintText: "input",
                ),
                onChanged: (string) {
                  _showDialog(context, string);
                },
              ),
              new TextFormField(),
              new Text(_inputText),
              new Switch(
                value: _offstage,
                onChanged: (value) {
                  setState(() {
                    _offstage = value;
                  });
                },
              ),
              new ClipOval(
                child: new Container(
                  color: Colors.greenAccent,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              new Transform(
                transform: Matrix4.rotationY(0.3),
                child: new Container(
                  color: Colors.blue,
                  height: 150.0,
                  width: 150.0,
                  padding: EdgeInsets.all(10.0),
                  child: new FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    widthFactor: null,
                    heightFactor: null,
                    child: new Container(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Baseline(
                    baseline: 50.0,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      width: 10.0,
                      height: 10.0,
                      color: Colors.red,
                    ),
                  ),
                  new Baseline(
                    baseline: 50.0,
                    baselineType: TextBaseline.alphabetic,
                    child: new Text(
                      "ByMjEq",
                      style: new TextStyle(
                        fontSize: 20.0,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                  new Baseline(
                    baseline: 50.0,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      width: 10.0,
                      height: 10.0,
                      color: Colors.red,
                    ),
                  ),
                  new Baseline(
                    baseline: 50.0,
                    baselineType: TextBaseline.alphabetic,
                    child: new Text(
                      "ByMjEq",
                      style: new TextStyle(
                        fontSize: 35.0,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                  new Baseline(
                    baseline: 50.0,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      width: 10.0,
                      height: 10.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              new ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 100.0,
                    maxWidth: 100.0,
                    minHeight: 50.0,
                    minWidth: 50.0),
                child: new AspectRatio(
                  aspectRatio: 1.0,
                  child: new Container(
                    color: Colors.amberAccent,
                    width: 100.0,
                    height: 100.0,
                    child: new FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.topLeft,
                      child: new Container(
                        child: new Text("fittedBox"),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              new Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
              new Offstage(
                offstage: _offstage,
                child: new Container(
                  color: Colors.green,
                  height: 100.0,
                ),
              ),
              new MaterialButton(
                  color: Colors.red,
                  child: new Text(_offstage ? "显示" : "隐藏"),
                  onPressed: () {
                    setState(() {
                      _offstage = !_offstage;
                    });
                  }),
              new DecoratedBox(
                decoration: new BoxDecoration(
                  gradient: new RadialGradient(
                    center: const Alignment(-0.5, -0.6),
                    radius: 0.15,
                    colors: <Color>[
                      Colors.red,
                      Colors.black38,
                    ],
                    stops: <double>[0.9, 1.0],
                  ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _getFlatButton('/a'),
                  _getFlatButton('/b'),
                  _getFlatButton('/c'),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showDialog(BuildContext context, String value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(value ?? ""),
          );
        });
  }

  FlatButton _getFlatButton(String router) {
    return new FlatButton(
      onPressed: () {
        Navigator.pushNamed(context, router).then((value) {
          if (value != null && value != "") {
            _showDialog(context, value);
          }
        });
      },
      child: new Text((router ?? "/").replaceAll("/", "").toUpperCase()),
    );
  }
}
