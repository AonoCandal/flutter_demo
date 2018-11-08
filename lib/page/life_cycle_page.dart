import 'package:flutter/material.dart';
import 'package:flutter_demo/notify/notify_manager.dart';

class LifeCyclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LifeCycleState();
  }
}

class LifeCycleState extends State<LifeCyclePage> {
  @override
  void initState() {
    print("life_cycle__initState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("life_cycle__didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("life_cycle__deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("life_cycle__dispose");
    super.dispose();
  }

  @override
  void didUpdateWidget(LifeCyclePage oldWidget) {
    print("life_cycle__didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("life_cycle__dispose");
    return Scaffold(
      body: ListView(
        children: <Widget>[
          RaisedButton(onPressed: _showDialog, child: Text("showDialog"))
        ],
      ),
    );
  }

  void _showDialog() {
    NotifyManager.getInstance().notifyChange('show_dialog');
  }
}
