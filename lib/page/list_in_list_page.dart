import 'package:flutter/material.dart';

class ListInListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListInListPageState();
  }
}

class ListInListPageState extends State<ListInListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(color: Colors.yellow, child: Text('adadad')),
                Container(color: Colors.yellow, child: Text('adadad')),
                Container(color: Colors.yellow, child: Text('adadad')),
                Container(color: Colors.yellow, child: Text('adadad')),
              ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: Text('list item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
