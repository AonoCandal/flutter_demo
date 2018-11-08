import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPageStatus();
}

class CalendarPageStatus extends State<CalendarPage> {
  String date = '无信息';

  List<DateTime> markedDates;
  List<DateTime> markedLightDates;

  List<DateTime> requestedMonth;

  @override
  void initState() {
    super.initState();
    requestedMonth = [DateTime(DateTime.now().year,DateTime.now().month,1)];
    markedDates = [DateTime(DateTime.now().year,DateTime.now().month, 2)];
    markedLightDates = [DateTime(DateTime.now().year,DateTime.now().month, 3)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
      ),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: CalendarCarousel(
            onDayPressed: null,
            thisMonthDayBorderColor: Color(0xffaaaaaa),
            height: double.infinity,
            headerBgColor: Color(0xFFFFF9E6),
            iconColor: Colors.black,
            dayPadding: 0.25,
            markedDates: markedDates,
            markedLightDates: markedLightDates,
            childAspectRatio: 0.875,
            weekdayTextStyle: TextStyle(fontSize: 14.0, color: Colors.black),
            weekEndDayTextStyle: TextStyle(fontSize: 14.0, color: Color(0xffaaaaaa)),
            headerTextStyle: TextStyle(fontSize: 18.0, color: Color(0xff251C00)),
            nextMonthTextStyle: TextStyle(fontSize: 15.0, color: Colors.black),
            prevMonthTextStyle: TextStyle(fontSize: 15.0, color: Colors.black),
            highLightTextStyle: TextStyle(fontSize: 15.0, color: Colors.red),
            listener: (DateTime time){
              getNextMonthDay(time);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(date),
        ),
      ],
    );
  }

  void getNextMonthDay(DateTime time) {
    if(!requestedMonth.contains(time)){
      Future.delayed(Duration(seconds: 2), (){
        if(mounted){
          setState(() {
            markedDates.addAll([DateTime(time.year, time.month, 2)]);
            markedLightDates.addAll([DateTime(time.year, time.month, 4)]);
            date = time.toIso8601String();
            requestedMonth.add(time);
          });
        }
      });
    }
  }
}
