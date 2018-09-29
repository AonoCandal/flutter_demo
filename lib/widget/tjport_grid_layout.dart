import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final List<Widget> widgets;
  final int crossAxisCount;

  GridLayout({@required this.widgets, this.crossAxisCount = 1});
  List<Widget> inputWidgets = [];
  int row;

  @override
  Widget build(BuildContext context) {
    inputWidgets.clear();
    inputWidgets.addAll(widgets);
    double rowD = inputWidgets.length / crossAxisCount;
    int rowI = inputWidgets.length ~/ crossAxisCount;
    row = rowD == rowI ? rowI : rowI + 1;
    while (inputWidgets.length < row * crossAxisCount) {
      inputWidgets.add(Container());
    }
    List<Row> rows = List(row);
    for (int i = 0; i < inputWidgets.length; i++) {
      if (rows[i ~/ crossAxisCount] == null) {
        rows[i ~/ crossAxisCount] = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Expanded(child: inputWidgets[i])],
        );
      } else {
        List<Widget> children = rows[i ~/ crossAxisCount].children;
        children.add(Expanded(child: inputWidgets[i]));
        rows[i ~/ crossAxisCount] = Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.start,
        );
      }
    }
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows,
      ),
    );
  }
}
