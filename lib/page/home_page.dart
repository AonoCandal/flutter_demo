import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildButton("homePage", '/home'),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String router) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: RaisedButton(
          child: Text(label),
          onPressed: () => Navigator.of(context).pushNamed(router)),
    );
  }
}
